FROM eclipse-temurin:17-jre-alpine

WORKDIR /opt/app

ARG artifact=target/*.jar
COPY ${artifact} app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]

