# 若依后端 Dockerfile
FROM docker.1ms.run/maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /build

COPY . .

RUN mvn clean package -DskipTests -B

FROM docker.1ms.run/eclipse-temurin:17-jre-alpine

RUN apk add --no-cache fontconfig ttf-dejavu

WORKDIR /ruoyi

COPY --from=builder /build/ruoyi-admin/target/ruoyi-admin.jar app.jar

EXPOSE 8080

ENV JAVA_OPTS="-Xms512m -Xmx1024m"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]