<!DOCTYPE html>
<html>
<head>
    <title>Вход - MentorFlow</title>
    <meta charset="UTF-8">
</head>
<body>
<h2>Вход в MentorFlow</h2>

<#if RequestParameters?? && RequestParameters.error??>
    <div style="color: red;">Неверный логин или пароль.</div>
</#if>

<#if RequestParameters?? && RequestParameters.logout??>
    <div style="color: green;">Вы успешно вышли из системы.</div>
</#if>

<form action="/login" method="post">
    <div>
        <label>Логин: <input type="text" name="username" required/></label>
    </div>
    <br>
    <div>
        <label>Пароль: <input type="password" name="password" required/></label>
    </div>
    <br>
    <button type="submit">Войти</button>
</form>
</body>
</html>