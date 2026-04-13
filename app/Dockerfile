FROM maven:3.9.9-eclipse-temurin-21-jammy AS build
WORKDIR /build

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests -Dcheckstyle.skip=true

FROM tomcat:10-jdk21
LABEL Project="Vprofile"
LABEL Author="Neel Lokhandwala"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /build/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

WORKDIR /usr/local/tomcat/
CMD ["catalina.sh", "run"]