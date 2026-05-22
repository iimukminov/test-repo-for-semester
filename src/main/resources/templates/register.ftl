<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Регистрация - MentorFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px 0; }
        .register-card { width: 100%; max-width: 450px; padding: 2rem; border-radius: 1rem; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15); border: none; }
        .brand-logo { width: 50px; height: 50px; background-color: #198754; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; margin: 0 auto 15px auto; }
    </style>
</head>
<body>

<div class="card register-card">
    <div class="text-center mb-4">
        <div class="brand-logo">M</div>
        <h3 class="fw-bold text-dark">Регистрация</h3>
        <p class="text-muted">Начните свой путь в MentorFlow</p>
    </div>

    <div id="errorMessage" class="alert alert-danger d-none py-2" role="alert">
        <small>Ошибка регистрации. Возможно, логин или email уже заняты.</small>
    </div>

    <form id="registerForm">
        <div class="form-floating mb-3">
            <input type="text" class="form-control" id="username" name="username" placeholder="Логин" required>
            <label for="username">Логин *</label>
        </div>

        <div class="form-floating mb-3">
            <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
            <label for="email">Email *</label>
        </div>

        <div class="form-floating mb-3">
            <input type="password" class="form-control" id="password" name="password" placeholder="Пароль" required>
            <label for="password">Пароль *</label>
        </div>

        <div class="form-floating mb-4">
            <input type="text" class="form-control" id="githubUsername" name="githubUsername" placeholder="GitHub Username">
            <label for="githubUsername">GitHub Username <span class="text-muted">(опционально)</span></label>
        </div>

        <button class="btn btn-success w-100 py-2 mb-3 fw-bold" type="submit">
            <span id="btnText">Зарегистрироваться</span>
            <span id="btnLoader" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
        </button>

        <div class="text-center">
            <span class="text-muted small">Уже есть аккаунт?</span>
            <a href="/login" class="text-decoration-none fw-bold text-success small">Войти</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const form = document.getElementById('registerForm');
    const btnText = document.getElementById('btnText');
    const btnLoader = document.getElementById('btnLoader');
    const submitBtn = form.querySelector('button[type="submit"]');

    form.addEventListener('submit', async function(event) {
        event.preventDefault();

        submitBtn.disabled = true;
        btnText.classList.add('d-none');
        btnLoader.classList.remove('d-none');
        document.getElementById('errorMessage').classList.add('d-none');

        const formData = new FormData(form);
        const data = Object.fromEntries(formData.entries());

        try {
            const response = await fetch('/api/v1/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (response.ok) {
                window.location.href = '/login?registered=true';
            } else {
                document.getElementById('errorMessage').classList.remove('d-none');
            }
        } catch (error) {
            console.error('Ошибка:', error);
            const errorAlert = document.getElementById('errorMessage');
            errorAlert.innerHTML = '<small>Сетевая ошибка. Сервер недоступен.</small>';
            errorAlert.classList.remove('d-none');
        } finally {
            // Возвращаем кнопку в исходное состояние
            submitBtn.disabled = false;
            btnText.classList.remove('d-none');
            btnLoader.classList.add('d-none');
        }
    });
</script>
</body>
</html>