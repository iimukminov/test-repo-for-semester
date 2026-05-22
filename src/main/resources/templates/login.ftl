<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Вход - MentorFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-card { width: 100%; max-width: 400px; padding: 2rem; border-radius: 1rem; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15); border: none; }
        .brand-logo { width: 50px; height: 50px; background-color: #0d6efd; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; margin: 0 auto 15px auto; }
    </style>
</head>
<body>

<div class="card login-card">
    <div class="text-center mb-4">
        <div class="brand-logo">M</div>
        <h3 class="fw-bold text-dark">MentorFlow</h3>
        <p class="text-muted">Добро пожаловать назад</p>
    </div>

    <#if RequestParameters?? && RequestParameters.error??>
        <div class="alert alert-danger py-2" role="alert">
            <small>Неверный логин или пароль!</small>
        </div>
    </#if>
    <#if RequestParameters?? && RequestParameters.logout??>
        <div class="alert alert-success py-2" role="alert">
            <small>Вы успешно вышли из системы.</small>
        </div>
    </#if>
    <#if RequestParameters?? && RequestParameters.registered??>
        <div class="alert alert-success py-2" role="alert">
            <small>Регистрация успешна! Теперь вы можете войти.</small>
        </div>
    </#if>

    <form action="/login" method="post">
        <div class="form-floating mb-3">
            <input type="text" class="form-control" id="username" name="username" placeholder="Логин" required>
            <label for="username">Логин</label>
        </div>
        <div class="form-floating mb-4">
            <input type="password" class="form-control" id="password" name="password" placeholder="Пароль" required>
            <label for="password">Пароль</label>
        </div>

        <button class="btn btn-primary w-100 py-2 mb-3 fw-bold" type="submit">Войти</button>

        <div class="text-center">
            <span class="text-muted small">Нет аккаунта?</span>
            <a href="/register" class="text-decoration-none fw-bold small">Зарегистрироваться</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>