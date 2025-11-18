# ===== 1) Build stage: compile and package WAR =====
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Create working directory
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY server ./server
COPY webapp ./webapp

# Build the webapp module and its dependencies
# (Assuming root pom has <modules><module>webapp</module><module>server</module></modules>
#   and webapp is packaged as <packaging>war</packaging>)
RUN mvn -B -pl webapp -am clean package

# ===== 2) Runtime stage: Tomcat + our WAR =====
FROM tomcat:8.5.66

# Optional: remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy our built WAR from the build stage
COPY --from=build /app/webapp/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat listens on 8080 by default
EXPOSE 8080

# Use Tomcat's default startup
CMD ["catalina.sh", "run"]

