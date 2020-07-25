# Stage-1
FROM maven:3.5-jdk-8-alpine as build
WORKDIR /app
COPY  . /app
RUN mvn install

FROM newtmitch/sonar-scanner as sonarqube
WORKDIR /code
COPY --from=build /app/target/* /code/
RUN sonar-scanner -Dsonar.projectBaseDir=/code -Dsonar.host.url="http://130.61.122.220:9000"

FROM openjdk:8-jre-alpine
WORKDIR /code
COPY --from=build /app/target/*.jar /code/
EXPOSE 8080
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar code/*.jar"]

