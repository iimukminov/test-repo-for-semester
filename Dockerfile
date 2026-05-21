FROM gradle:8.10-jdk23 AS builder
WORKDIR /app

# Копируем файлы конфигурации сборки
COPY build.gradle settings.gradle ./

# Копируем исходный код проекта
COPY src ./src

# Собираем исполняемый JAR файл (пропускаем тесты для ускорения сборки)
RUN gradle bootJar -x test

# Используем оптимизированный образ Eclipse Temurin для JDK 23 на базе Alpine Linux
FROM eclipse-temurin:23-jre-alpine
WORKDIR /app

# Копируем собранный JAR-файл из первого этапа (builder)
COPY --from=builder /app/build/libs/*.jar app.jar

# Открываем стандартный порт Tomcat
EXPOSE 8080

# Точка входа: запускаем наше Spring Boot приложение
ENTRYPOINT ["java", "-jar", "app.jar"]