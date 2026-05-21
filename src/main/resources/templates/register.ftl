<!DOCTYPE html>
<html>
<head>
    <title>Регистрация - MentorFlow</title>
    <meta charset="UTF-8">
</head>
<body>
<h2>Регистрация в MentorFlow</h2>

<form action="/users" method="post">
    <div>
        <label>Логин: <input type="text" name="username" required/></label>
    </div>
    <br>
    <div>
        <label>Email: <input type="email" name="email" required/></label>
    </div>
    <br>
    <div>
        <label>Пароль: <input type="password" name="password" required/></label>
    </div>
    <br>
    <div>
        <label>GitHub Username: <input type="text" name="githubUsername"/></label>
    </div>
    <br>
    <button type="submit">Зарегистрироваться</button>
</form>
</body>
</html>