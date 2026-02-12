# 1. 자바 11이 포함된 톰캣 9 이미지를 가져옵니다.
FROM tomcat:9.0-jdk17-openjdk-slim

# 2. 톰캣 기본 웹앱을 삭제하고 내 프로젝트를 ROOT로 설정합니다.
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. 빌드된 war 파일을 톰캣의 ROOT.war로 복사합니다.
# 이렇게 하면 접속 주소가 localhost:8888/ 이 됩니다.
COPY build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

# 4. 8080 포트를 사용합니다.
EXPOSE 8080

# 5. 톰캣 실행
CMD ["catalina.sh", "run"]