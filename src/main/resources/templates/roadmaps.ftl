<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Дорожные карты - MentorFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="/">MentorFlow</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link text-danger" href="/logout">Выйти</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row mb-4">
        <div class="col">
            <h2 class="display-6">Список дорожных карт</h2>
            <p class="text-muted">Управляйте процессом обучения</p>
        </div>
        <div class="col-auto d-flex align-items-center gap-2">
            <button class="btn btn-warning" onclick="testAjaxError()">Тест AJAX Ошибки</button>
            <a href="/test-error" class="btn btn-danger">Тест HTML Ошибки</a>
        </div>
    </div>

    <div class="row row-cols-1 row-cols-md-2 g-4">
        <#if roadmaps?? && roadmaps?size &gt; 0>
            <#list roadmaps as roadmap>
                <div class="col">
                    <div class="card h-100 shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h5 class="card-title mb-0">${roadmap.title}</h5>
                        </div>
                        <div class="card-body">
                            <p class="card-text">${roadmap.description!"Описание отсутствует"}</p>
                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item px-0"><strong>Ментор:</strong> @${roadmap.mentorUsername}</li>
                                <li class="list-group-item px-0"><strong>Менти:</strong> @${roadmap.menteeUsername}</li>
                            </ul>
                        </div>
                        <div class="card-footer bg-white border-top-0">
                            <small class="text-muted">Создано: <#if roadmap.createdAt??>${roadmap.createdAt}<#else>Неизвестно</#if></small>
                        </div>
                    </div>
                </div>
            </#list>
        <#else>
            <div class="col-12">
                <div class="alert alert-info" role="alert">
                    Пока нет ни одной дорожной карты.
                </div>
            </div>
        </#if>
    </div>
</div>

<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
    <div id="errorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="errorToastMessage">
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    async function testAjaxError() {
        try {
            const response = await fetch('/steps/999999/status', {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ status: 'INVALID_STATUS' })
            });

            const data = await response.json();

            if (!response.ok) {
                document.getElementById('errorToastMessage').innerText = 'Ошибка сервера: ' + data.message;
                const toast = new bootstrap.Toast(document.getElementById('errorToast'));
                toast.show();
            }
        } catch (error) {
            console.error('Сетевая ошибка:', error);
        }
    }
</script>

</body>
</html>