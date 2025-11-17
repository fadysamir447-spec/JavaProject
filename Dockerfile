# Use a lightweight JRE image for running the app
FROM eclipse-temurin:17-jre

# App working directory
WORKDIR /app

# Copy the built JAR from the Maven build step
# Tekton builds the project in /workspace/source and the Docker context is the repo root,
# so "target/*.jar" will contain the jar we just built.
COPY target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

