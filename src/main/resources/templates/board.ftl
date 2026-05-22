<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Доска заявок - MentorFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .navbar { box-shadow: 0 2px 4px rgba(0,0,0,.08); }
        .ad-card { border: none; border-radius: 12px; transition: transform 0.2s, box-shadow 0.2s; }
        .ad-card:hover { transform: translateY(-3px); box-shadow: 0 8px 15px rgba(0,0,0,.1) !important; }
        .nav-pills .nav-link.active { background-color: #0d6efd; font-weight: bold; }
        .nav-pills .nav-link { color: #495057; font-weight: 500; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 py-3">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/"><i class="bi bi-layers-fill text-primary me-2"></i>MentorFlow</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="/roadmap">Мои карты</a></li>
                <li class="nav-item"><a class="nav-link active" href="/board">Биржа</a></li>
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
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-dark mb-1">Доска заявок</h2>
            <p class="text-muted mb-0">Найдите своего идеального наставника или ученика</p>
        </div>
        <button class="btn btn-primary fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#createAdModal">
            <i class="bi bi-megaphone me-1"></i> Опубликовать анкету
        </button>
    </div>

    <ul class="nav nav-pills mb-4" id="boardTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active px-4 rounded-pill me-2" id="seeking-mentor-tab" data-bs-toggle="pill" data-type="SEEKING_MENTOR" type="button" role="tab">Ищут наставника (Джуны)</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link px-4 rounded-pill" id="seeking-mentee-tab" data-bs-toggle="pill" data-type="SEEKING_MENTEE" type="button" role="tab">Готовы обучать (Менторы)</button>
        </li>
    </ul>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="adsContainer">
        <div class="col-12 text-center py-5 w-100" id="loadingSpinner">
            <div class="spinner-border text-primary" role="status"></div>
            <p class="mt-2 text-muted">Загрузка заявок...</p>
        </div>
    </div>
</div>

<div class="modal fade" id="createAdModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Новая анкета</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form id="createAdForm">
                    <input type="hidden" name="authorId" value="${currentUserId}">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Кого вы ищете?</label>
                        <select class="form-select" name="type" required>
                            <option value="SEEKING_MENTOR">Я ищу Ментора (Я ученик)</option>
                            <option value="SEEKING_MENTEE">Я ищу Ученика (Я ментор)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Заголовок (Стек технологий)</label>
                        <input type="text" class="form-control" name="title" required placeholder="Например: Изучаю Java, Spring Boot, Kafka">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">О себе и требования</label>
                        <textarea class="form-control" name="content" rows="4" required placeholder="Опишите свой текущий уровень, опыт и чего ждете от сотрудничества..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2" id="submitAdBtn">Опубликовать</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="replyModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-success text-white border-0">
                <h5 class="modal-title fw-bold"><i class="bi bi-send-fill me-2"></i>Откликнуться</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form id="replyForm">
                    <input type="hidden" id="replyAdId">
                    <input type="hidden" name="senderId" value="${currentUserId}">
                    <p class="text-muted small mb-3">Ваш отклик будет отправлен пользователю <strong id="replyAuthorName"></strong></p>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Сопроводительное письмо</label>
                        <textarea class="form-control" name="coverLetter" rows="3" required placeholder="Привет! Я могу помочь тебе с..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-success w-100 fw-bold py-2" id="submitReplyBtn">Отправить отклик</button>
                </form>
            </div>
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
    const adsContainer = document.getElementById('adsContainer');

    // Загрузка объявлений
    async function loadAds(type) {
        adsContainer.innerHTML = '<div class="col-12 text-center py-5 w-100"><div class="spinner-border text-primary"></div></div>';
        try {
            const res = await fetch('/api/v1/board?type=' + type);
            if (!res.ok) throw new Error('Ошибка загрузки');
            const ads = await res.json();

            if (ads.length === 0) {
                adsContainer.innerHTML = '<div class="col-12 text-center py-5 text-muted"><i class="bi bi-inbox fs-1"></i><p class="mt-2">В этой категории пока нет заявок</p></div>';
                return;
            }

            adsContainer.innerHTML = ads.map(ad => `
                <div class="col">
                    <div class="card ad-card h-100 shadow-sm border-0">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-light text-dark border"><i class="bi bi-person-circle me-1"></i> @\${ad.authorUsername}</span>
                                <small class="text-muted">\${new Date(ad.createdAt).toLocaleDateString()}</small>
                            </div>
                            <h5 class="fw-bold mb-3">\${ad.title}</h5>
                            <p class="text-muted small mb-4" style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                \${ad.content}
                            </p>
                        </div>
                        <div class="card-footer bg-transparent border-top-0 pb-3 pt-0">
                            \${ad.authorId !== currentUserId ?
                                `<button class="btn btn-outline-primary w-100 fw-bold" onclick="openReplyModal(\${ad.id}, '\${ad.authorUsername}')">Откликнуться</button>` :
                                `<button class="btn btn-secondary w-100 fw-bold" disabled>Ваша анкета</button>`
                            }
                        </div>
                    </div>
                </div>
            `).join('');
        } catch (e) {
            showToast('Не удалось загрузить заявки', 'danger');
        }
    }

    // Переключение вкладок
    document.querySelectorAll('.nav-link[data-bs-toggle="pill"]').forEach(tab => {
        tab.addEventListener('shown.bs.tab', (e) => loadAds(e.target.dataset.type));
    });

    // Создание объявления
    document.getElementById('createAdForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const btn = document.getElementById('submitAdBtn');
        btn.disabled = true;

        const data = Object.fromEntries(new FormData(this).entries());
        data.authorId = parseInt(data.authorId);

        try {
            const res = await fetch('/api/v1/board', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            if (res.ok) {
                window.location.reload();
            } else throw new Error();
        } catch (e) { showToast('Ошибка публикации', 'danger'); btn.disabled = false; }
    });

    // Открытие модалки отклика
    function openReplyModal(adId, authorUsername) {
        document.getElementById('replyAdId').value = adId;
        document.getElementById('replyAuthorName').innerText = '@' + authorUsername;
        new bootstrap.Modal(document.getElementById('replyModal')).show();
    }

    // Отправка отклика
    document.getElementById('replyForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const btn = document.getElementById('submitReplyBtn');
        btn.disabled = true;

        const adId = document.getElementById('replyAdId').value;
        const data = Object.fromEntries(new FormData(this).entries());
        data.senderId = parseInt(data.senderId);

        try {
            const res = await fetch('/api/v1/board/' + adId + '/reply', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            if (res.ok) {
                showToast('Ваш отклик успешно отправлен!', 'success');
                setTimeout(() => window.location.reload(), 1500);
            } else throw new Error();
        } catch (e) { showToast('Ошибка отправки отклика', 'danger'); btn.disabled = false; }
    });

    function showToast(msg, type) {
        const toastEl = document.getElementById('statusToast');
        toastEl.className = 'toast align-items-center border-0 text-bg-' + type;
        document.getElementById('statusToastMessage').innerText = msg;
        new bootstrap.Toast(toastEl).show();
    }

    // Загружаем Джунов при старте страницы
    document.addEventListener('DOMContentLoaded', () => loadAds('SEEKING_MENTOR'));
</script>

</body>
</html>