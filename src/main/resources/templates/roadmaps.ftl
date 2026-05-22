<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Панель обучения - MentorFlow</title>
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
            <h2 class="fw-bold text-dark mb-1">
                <#if isMentor>Ваши дорожные карты<#else>Ваш план обучения</#if>
            </h2>
            <p class="text-muted mb-0">
                <#if isMentor>Управляйте процессом обучения ваших подопечных<#else>Следите за своим прогрессом и выполняйте задания вовремя</#if>
            </p>
        </div>
        <#if isMentor>
            <button class="btn btn-primary fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#createRoadmapModal">
                <i class="bi bi-plus-lg me-1"></i> Создать карту
            </button>
        </#if>
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <#if roadmaps?? && roadmaps?size &gt; 0>
            <#list roadmaps as roadmap>
                <div class="col">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-3">
                                <div class="icon-box"><i class="bi bi-map"></i></div>
                                <span class="badge bg-success status-badge d-flex align-items-center">В процессе</span>
                            </div>
                            <h5 class="card-title fw-bold mb-3">${roadmap.title}</h5>

                            <ul class="list-unstyled mb-4">
                                <#if isMentor>
                                    <li class="mb-2 text-muted"><i class="bi bi-person-badge me-2 text-secondary"></i><strong>Студент:</strong> @${roadmap.menteeUsername}</li>
                                <#else>
                                    <li class="mb-2 text-muted"><i class="bi bi-person-workspace me-2 text-secondary"></i><strong>Наставник:</strong> @${roadmap.mentorUsername}</li>
                                </#if>
                                <li class="mb-2 text-muted"><i class="bi bi-hourglass-bottom me-2 text-warning"></i><strong>Контроль AFK:</strong> ${roadmap.maxAfkDays!5} дней</li>
                                <#if roadmap.meetLink?? && roadmap.meetLink != "">
                                    <li class="text-truncate text-muted"><i class="bi bi-link-45deg me-2 text-primary"></i><a href="${roadmap.meetLink}" target="_blank" class="text-decoration-none fw-bold">Комната созвонов</a></li>
                                </#if>
                            </ul>
                        </div>

                        <div class="card-footer bg-transparent border-top d-flex justify-content-between align-items-center py-3">
                            <small class="text-muted"><i class="bi bi-calendar3 me-1"></i> Активна</small>
                            <#if isMentor>
                                <button class="btn btn-sm btn-outline-primary fw-bold" onclick="openAddStepModal(${roadmap.id}, '${roadmap.title}')">
                                    <i class="bi bi-plus-circle me-1"></i> Добавить шаг
                                </button>
                            </#if>
                        </div>
                    </div>
                </div>
            </#list>
        <#else>
            <div class="col-12 text-center py-5">
                <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
                <h4 class="mt-3 text-muted">Дорожных карт пока нет</h4>
                <p class="text-muted">
                    <#if isMentor>Нажмите «Создать карту», чтобы прикрепить ученика.<#else>Ваш ментор еще не добавил для вас программу обучения.</#if>
                </p>
            </div>
        </#if>
    </div>
</div>

<#if isMentor>
    <div class="modal fade" id="createRoadmapModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white border-0">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Новая дорожная карта</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="createRoadmapForm">
                        <input type="hidden" name="mentorId" value="${currentUserId}">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Название курса</label>
                            <input type="text" class="form-control" name="title" required placeholder="Например: Разработка на Kafka">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ученик (Менти)</label>
                            <select class="form-select" name="menteeId" required>
                                <option value="" disabled selected>Выберите ученика...</option>
                                <#if mentees??>
                                    <#list mentees as mentee>
                                        <#if mentee.getId() != currentUserId>
                                            <option value="${mentee.getId()}">@${mentee.getUsername()}</option>
                                        </#if>
                                    </#list>
                                </#if>
                            </select>
                        </div>
                        <div class="p-3 bg-light rounded-3 border mb-3">
                            <h6 class="fw-bold mb-3 text-danger"><i class="bi bi-robot me-1"></i>Авто-контроль успеваемости</h6>
                            <div class="mb-3">
                                <label class="form-label">Максимум дней простоя (AFK)</label>
                                <input type="number" class="form-control" name="maxAfkDays" value="5" min="1" required>
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

    <div class="modal fade" id="addStepModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white border-0">
                    <h5 class="modal-title fw-bold"><i class="bi bi-node-plus-fill me-2"></i>Добавить шаг в <span id="stepRoadmapTitle"></span></h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="addStepForm">
                        <input type="hidden" id="stepRoadmapId">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Порядковый номер шага</label>
                            <input type="number" class="form-control" name="stepOrder" min="1" value="1" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Заголовок задания</label>
                            <input type="text" class="form-control" name="title" required placeholder="Изучить Consumer Groups">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ссылка на репозиторий проекта</label>
                            <input type="url" class="form-control" name="contentLink" required placeholder="https://github.com/...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold text-success">Требуемое кол-во коммитов</label>
                            <input type="number" class="form-control" name="requiredCommits" min="1" value="3" required>
                        </div>
                        <button type="submit" class="btn btn-success w-100 fw-bold py-2" id="submitStepBtn">Сохранить шаг</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</#if>

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
    <#if isMentor>
    document.getElementById('createRoadmapForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;

        const formData = new FormData(this);
        const data = Object.fromEntries(formData.entries());
        data.mentorId = parseInt(data.mentorId);
        data.menteeId = parseInt(data.menteeId);
        data.maxAfkDays = parseInt(data.maxAfkDays);

        try {
            const res = await fetch('/api/v1/roadmaps', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify(data)
            });
            if (res.ok) {
                window.location.reload();
            } else {
                const err = await res.json();
                showToast('Ошибка: ' + (err.message || 'Проверьте данные'), 'danger');
            }
        } catch (error) {
            showToast('Сетевая ошибка', 'danger');
        } finally {
            btn.disabled = false;
        }
    });

    function openAddStepModal(roadmapId, roadmapTitle) {
        document.getElementById('stepRoadmapId').value = roadmapId;
        document.getElementById('stepRoadmapTitle').innerText = '"' + roadmapTitle + '"';
        new bootstrap.Modal(document.getElementById('addStepModal')).show();
    }

    document.getElementById('addStepForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const btn = document.getElementById('submitStepBtn');
        btn.disabled = true;

        const roadmapId = document.getElementById('stepRoadmapId').value;
        const formData = new FormData(this);
        const data = Object.fromEntries(formData.entries());
        data.stepOrder = parseInt(data.stepOrder);
        data.requiredCommits = parseInt(data.requiredCommits);

        try {
            const res = await fetch('/api/v1/roadmaps/' + roadmapId + '/steps', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify(data)
            });
            if (res.ok) {
                showToast('Шаг успешно добавлен!', 'success');
                setTimeout(() => window.location.reload(), 1000);
            } else {
                showToast('Ошибка при добавлении шага', 'danger');
            }
        } catch (error) {
            showToast('Сетевая ошибка', 'danger');
        } finally {
            btn.disabled = false;
        }
    });
    </#if>

    function showToast(msg, type) {
        const toastEl = document.getElementById('statusToast');
        toastEl.className = 'toast align-items-center border-0 text-bg-' + type;
        document.getElementById('statusToastMessage').innerText = msg;
        new bootstrap.Toast(toastEl).show();
    }
</script>

</body>
</html>