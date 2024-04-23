FROM maven:3.8.6-amazoncorretto-17 AS step1
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY . .
RUN mvn clean package -Dmaven.test.skip=true -Dquarkus.profile=dev
 

FROM amazoncorretto:17-alpine AS step2
WORKDIR /deployments
COPY --from=step1 /app/target/quarkus-app/lib lib/
COPY --from=step1 /app/target/quarkus-app/app app/
COPY --from=step1 /app/target/quarkus-app/quarkus quarkus/
COPY --from=step1 /app/target/quarkus-app/*.jar ./
CMD java -jar /deployments/quarkus-run.jar 
