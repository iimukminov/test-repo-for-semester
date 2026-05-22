<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Дашборд Ментора - MentorFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .navbar { box-shadow: 0 2px 4px rgba(0,0,0,.08); }
        .card { border: none; border-radius: 12px; transition: transform 0.2s, box-shadow 0.2s; }
        .card:hover { transform: translateY(-3px); box-shadow: 0 8px 15px rgba(0,0,0,.1) !important; }
        .status-badge { font-size: 0.8rem; padding: 0.4em 0.8em; border-radius: 20px; }
        .icon-box { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 10px; background: rgba(13, 110, 253, 0.1); color: #0d6efd; font-size: 1.2rem; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 py-3">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/"><i class="bi bi-layers-fill text-primary me-2"></i>MentorFlow</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="btn btn-outline-light btn-sm rounded-pill px-4" href="/logout"><i class="bi bi-box-arrow-right me-1"></i> Выйти</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="d-flex justify-content-between align-items-center mb-5 border-bottom pb-3">
        <div>
            <h2 class="fw-bold text-dark mb-1">Дорожные карты</h2>
            <p class="text-muted mb-0">Управляйте процессом обучения ваших подопечных</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-danger" onclick="testAjaxError()"><i class="bi bi-bug me-1"></i> Ошибка (AJAX)</button>
            <button class="btn btn-primary fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#createRoadmapModal">
                <i class="bi bi-plus-lg me-1"></i> Создать карту
            </button>
        </div>
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <#if roadmaps?? && roadmaps?size &gt; 0>
            <#list roadmaps as roadmap>
                <div class="col">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-3">
                                <div class="icon-box"><i class="bi bi-map"></i></div>
                                <span class="badge bg-success status-badge d-flex align-items-center">Активна</span>
                            </div>
                            <h5 class="card-title fw-bold mb-3">${roadmap.title}</h5>

                            <ul class="list-unstyled mb-4">
                                <li class="mb-2 text-muted"><i class="bi bi-person-workspace me-2 text-secondary"></i><strong>Ментор:</strong> @${roadmap.mentorUsername}</li>
                                <li class="mb-2 text-muted"><i class="bi bi-person-video me-2 text-secondary"></i><strong>Менти:</strong> @${roadmap.menteeUsername}</li>
                                <li class="mb-2 text-muted"><i class="bi bi-hourglass-bottom me-2 text-warning"></i><strong>Лимит AFK:</strong> ${roadmap.maxAfkDays!5} дней</li>
                                <#if roadmap.meetLink??>
                                    <li class="text-truncate text-muted"><i class="bi bi-link-45deg me-2 text-primary"></i><a href="${roadmap.meetLink}" target="_blank" class="text-decoration-none">Ссылка на созвон</a></li>
                                </#if>
                            </ul>
                        </div>
                        <div class="card-footer bg-transparent border-top text-center py-3">
                            <small class="text-muted"><i class="bi bi-calendar3 me-1"></i> Создано: <#if roadmap.createdAt??>${roadmap.createdAt}<#else>Неизвестно</#if></small>
                        </div>
                    </div>
                </div>
            </#list>
        <#else>
            <div class="col-12 text-center py-5">
                <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
                <h4 class="mt-3 text-muted">Пока нет ни одной дорожной карты</h4>
                <p class="text-muted">Нажмите «Создать карту», чтобы начать работу с учениками.</p>
            </div>
        </#if>
    </div>
</div>

<div class="modal fade" id="createRoadmapModal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title fw-bold" id="modalLabel"><i class="bi bi-pencil-square me-2"></i>Новая дорожная карта</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="createRoadmapForm">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Название курса</label>
                        <input type="text" class="form-control" name="title" required placeholder="Например: Основы Spring Boot">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Описание</label>
                        <textarea class="form-control" name="description" rows="2" placeholder="Краткое описание курса..."></textarea>
                    </div>

                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label fw-bold">ID Ментора</label>
                            <select class="form-select" id="mentorSelect" name="mentorId" required>
                                <option value="">Загрузка...</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-bold">ID Менти</label>
                            <select class="form-select" id="menteeSelect" name="menteeId" required>
                                <option value="">Загрузка...</option>
                            </select>
                        </div>
                    </div>

                    <div class="p-3 bg-light rounded-3 border mb-3">
                        <h6 class="fw-bold mb-3 text-danger"><i class="bi bi-robot me-1"></i>Авто-контроль (Киллер-фича)</h6>
                        <div class="mb-3">
                            <label class="form-label">Максимум дней простоя (AFK)</label>
                            <input type="number" class="form-control" name="maxAfkDays" value="5" min="1" required>
                            <div class="form-text">Через сколько дней без коммитов назначить созвон?</div>
                        </div>
                        <div>
                            <label class="form-label">Ссылка для авто-созвона</label>
                            <input type="url" class="form-control" name="meetLink" placeholder="https://meet.google.com/..." required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2" id="submitBtn">Создать карту</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="errorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold" id="errorToastMessage"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', async () => {
        try {
            const res = await fetch('/users');
            if(res.ok) {
                const users = await res.json();
                const mentorSelect = document.getElementById('mentorSelect');
                const menteeSelect = document.getElementById('menteeSelect');

                mentorSelect.innerHTML = '';
                menteeSelect.innerHTML = '';

                users.forEach(u => {
                    const option = `<option value="${u.id}">${u.username}</option>`;
                    mentorSelect.innerHTML += option;
                    menteeSelect.innerHTML += option;
                });
            }
        } catch (e) { console.error('Не удалось загрузить пользователей', e); }
    });

    document.getElementById('createRoadmapForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Создание...';

        const formData = new FormData(this);
        const data = Object.fromEntries(formData.entries());
        data.mentorId = parseInt(data.mentorId);
        data.menteeId = parseInt(data.menteeId);
        data.maxAfkDays = parseInt(data.maxAfkDays);

        try {
            const res = await fetch('/roadmaps', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify(data)
            });

            if (res.ok) {
                window.location.reload();
            } else {
                showToast('Ошибка при создании карты');
                btn.disabled = false;
                btn.innerHTML = 'Создать карту';
            }
        } catch (error) {
            showToast('Сетевая ошибка');
            btn.disabled = false;
            btn.innerHTML = 'Создать карту';
        }
    });

    // Тест глобальной обработки AJAX ошибок
    async function testAjaxError() {
        try {
            const response = await fetch('/steps/999999/status', {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
                body: JSON.stringify({ status: 'INVALID_STATUS' })
            });
            const data = await response.json();
            if (!response.ok) showToast('Ошибка сервера: ' + data.message);
        } catch (error) { showToast('Сетевая ошибка'); }
    }

    function showToast(msg) {
        document.getElementById('errorToastMessage').innerText = msg;
        new bootstrap.Toast(document.getElementById('errorToast')).show();
    }
</script>

</body>
</html>