FROM maven:3.8.5-eclipse-temurin-17 AS build

COPY src /app/src
COPY pom.xml /app

WORKDIR /app

# Realiza o build do projeto
RUN mvn clean install -DskipTests -X

# Etapa de execução com Java 17
FROM eclipse-temurin:17-jre-alpine

# Copia o WAR gerado na etapa de build
COPY --from=build /app/target/Prova1AdminFilipeRodrigues-0.0.1-SNAPSHOT.war /app/app.war

WORKDIR /app

# Configura variáveis de ambiente (menos a senha, que será lida via Docker Secret)
ENV SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/restaurante
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_JPA_HIBERNATE_DDL_AUTO=false

# Expõe a porta da aplicação
EXPOSE 8080

# Comando para rodar o aplicativo
CMD ["java", "-jar", "/app/app.war"]