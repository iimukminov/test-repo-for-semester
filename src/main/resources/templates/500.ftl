<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Ошибка сервера - MentorFlow</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; color: #333; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .error-container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-width: 600px; text-align: center; }
        h1 { color: #dc3545; }
        .details { background: #f1f1f1; padding: 15px; border-radius: 5px; font-family: monospace; color: #555; text-align: left; margin-top: 20px; word-wrap: break-word; }
        a.button { display: inline-block; margin-top: 20px; padding: 10px 20px; background-color: #0d6efd; color: white; text-decoration: none; border-radius: 5px; }
        a.button:hover { background-color: #0b5ed7; }
    </style>
</head>
<body>
<div class="error-container">
    <h1>Ой, что-то пошло не так! 🛠️</h1>
    <p>Произошла непредвиденная ошибка на сервере. Мы уже в курсе и работаем над этим.</p>

    <#if errorMessage??>
        <div class="details">
            <strong>Детали ошибки:</strong><br>
            ${errorMessage}
        </div>
    </#if>

    <a href="/" class="button">Вернуться на главную</a>
</div>
</body>
</html>