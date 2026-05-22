<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Уведомления - MentorFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .navbar { box-shadow: 0 2px 4px rgba(0,0,0,.08); }
        .req-card { border: none; border-radius: 12px; border-left: 5px solid #0d6efd; transition: all 0.3s ease; }
        .req-card.ACCEPTED { border-left-color: #198754; background-color: #f8fff9; opacity: 0.8; }
        .req-card.REJECTED { border-left-color: #dc3545; background-color: #fffaf8; opacity: 0.6; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 py-3">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/"><i class="bi bi-layers-fill text-primary me-2"></i>MentorFlow</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="/roadmap">Мои карты</a></li>
                <li class="nav-item"><a class="nav-link" href="/board">Биржа</a></li>
                <li class="nav-item"><a class="nav-link active" href="/notifications">Отклики</a></li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="btn btn-outline-light btn-sm rounded-pill px-4" href="/logout"><i class="bi bi-box-arrow-right me-1"></i> Выйти</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="mb-4">
        <h2 class="fw-bold text-dark mb-1">Входящие отклики</h2>
        <p class="text-muted mb-0">Люди, которые хотят с вами работать</p>
    </div>

    <div class="row" id="requestsContainer">
        <div class="col-12 text-center py-5" id="loadingSpinner">
            <div class="spinner-border text-primary" role="status"></div>
            <p class="mt-2 text-muted">Проверяем входящие...</p>
        </div>
    </div>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="statusToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold text-white" id="statusToastMessage"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const currentUserId = ${currentUserId};
    const container = document.getElementById('requestsContainer');

    document.addEventListener('DOMContentLoaded', loadRequests);

    async function loadRequests() {
        try {
            const res = await fetch('/api/v1/connections/requests?userId=' + currentUserId);
            if (!res.ok) throw new Error();
            const requests = await res.json();

            if (requests.length === 0) {
                container.innerHTML = '<div class="col-12 text-center py-5 text-muted"><i class="bi bi-envelope-open fs-1"></i><p class="mt-2">У вас пока нет новых откликов</p></div>';
                return;
            }

            container.innerHTML = requests.map(req => {
                let actionButtons = '';
                if (req.status === 'PENDING') {
                    actionButtons = `
                        <button class="btn btn-success fw-bold w-100 mb-2" onclick="updateStatus(${req.id}, 'ACCEPTED')">
                            <i class="bi bi-check-lg me-1"></i> Принять
                        </button>
                        <button class="btn btn-outline-danger fw-bold w-100" onclick="updateStatus(${req.id}, 'REJECTED')">
                            <i class="bi bi-x-lg me-1"></i> Отказать
                        </button>
                    `;
                } else {
                    const badgeClass = req.status === 'ACCEPTED' ? 'bg-success' : 'bg-danger';
                    const badgeText = req.status === 'ACCEPTED' ? 'Заявка принята' : 'Заявка отклонена';
                    actionButtons = `<span class="badge ${badgeClass} fs-6 p-2 w-100">${badgeText}</span>`;
                }

                return `
                    <div class="col-12 mb-3">
                        <div class="card req-card shadow-sm ${req.status}">
                            <div class="card-body p-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                                <div class="flex-grow-1">
                                    <div class="mb-2">
                                        <span class="badge bg-secondary me-2">${new Date(req.createdAt).toLocaleDateString()}</span>
                                        <span class="text-muted small">На объявление: <strong>${req.advertisementTitle}</strong></span>
                                    </div>
                                    <h5 class="fw-bold mb-2"><i class="bi bi-person-circle text-primary me-2"></i>@${req.senderUsername}</h5>
                                    <div class="p-3 bg-light rounded text-dark fst-italic border">
                                        "${req.coverLetter}"
                                    </div>
                                </div>
                                <div class="d-flex flex-column" style="min-width: 150px;">
                                    ${actionButtons}
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');

        } catch (e) {
            showToast('Ошибка загрузки откликов', 'danger');
            container.innerHTML = '<div class="col-12 text-center text-danger py-4">Не удалось загрузить данные</div>';
        }
    }

    async function updateStatus(requestId, newStatus) {
        try {
            const res = await fetch('/api/v1/connections/requests/' + requestId, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ status: newStatus })
            });

            if (res.ok) {
                showToast(newStatus === 'ACCEPTED' ? 'Ученик добавлен!' : 'Заявка отклонена', newStatus === 'ACCEPTED' ? 'success' : 'secondary');
                loadRequests(); // Перерисовываем список
            } else {
                throw new Error();
            }
        } catch (e) {
            showToast('Ошибка при обновлении статуса', 'danger');
        }
    }

    function showToast(msg, type) {
        const toastEl = document.getElementById('statusToast');
        toastEl.className = 'toast align-items-center border-0 text-bg-' + type;
        document.getElementById('statusToastMessage').innerText = msg;
        new bootstrap.Toast(toastEl).show();
    }
</script>
</body>
</html>