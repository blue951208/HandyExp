# 1단계: 빌드 스테이지 (Gradle을 이용해 WAR 파일 생성)
FROM gradle:7.6-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# Gradle 빌드 실행 (테스트 생략으로 속도 향상)
RUN gradle clean build -x test

# 2단계: 실행 스테이지 (톰캣에 빌드된 WAR 복사)
FROM tomcat:9.0-jdk17-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# 1단계에서 생성된 war 파일을 가져옵니다.
COPY --from=build /home/gradle/src/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]