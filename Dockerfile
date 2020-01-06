FROM maven@sha256:b37da91062d450f3c11c619187f0207bbb497fc89d265a46bbc6dc5f17c02a2b AS build
# The above is a temporary fix
# See:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=911925
# https://github.com/carlossg/docker-maven/issues/92
# FROM maven:3-jdk-8-slim AS build
#Pass build args into env vars
ARG CI
ENV CI=$CI

ARG SONAR_HOST_URL
ENV SONAR_HOST_URL=$SONAR_HOST_URL

ARG SONAR_LOGIN
ENV SONAR_LOGIN=$SONAR_LOGIN

COPY pom.xml /build/pom.xml
WORKDIR /build

RUN if wget -q 'https://s3-us-west-2.amazonaws.com/prod-owi-resources/resources/InstallFiles/SSL/DOIRootCA.cer'; then \
    keytool -import -trustcacerts -file DOIRootCA.cer -alias DOIRootCA.cer -keystore $JAVA_HOME/jre/lib/security/cacerts -noprompt -storepass changeit; \
  fi

#download all maven dependencies (this will only re-run if the pom has changed)
#suppress INFO-level logs about dependency downloads to permit the build to succed within Travis' log length limits
RUN mvn -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn dependency:go-offline

COPY src /build/src

#Sonar needs commit history to do reporting
COPY .git /build

ARG BUILD_COMMAND="mvn -B clean verify"
RUN ${BUILD_COMMAND}

FROM usgswma/wma-spring-boot-base:8-jre-slim-0.0.4

ENV serverPort=7505
ENV javaToRServiceEndpoint=https://reporting-services.nwis.usgs.gov:7500/aqcu-java-to-r/
ENV aqcuReportsWebserviceUrl=https://reporting.nwis.usgs.gov/aqcu/timeseries-ws/
ENV aquariusServiceEndpoint=http://ts.nwis.usgs.gov
ENV aquariusServiceUser=apinwisra
ENV hystrixThreadTimeout=300000
ENV hystrixMaxQueueSize=200
ENV hystrixThreadPoolSize=10
ENV oauthResourceId=resource-id
ENV oauthResourceTokenKeyUri=https://example.gov/oauth/token_key
ENV HEALTHY_RESPONSE_CONTAINS='{"status":{"code":"UP","description":""}'

COPY --chown=1000:1000 --from=build /build/target/*.jar app.jar

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -k "https://127.0.0.1:${serverPort}${serverContextPath}${HEALTH_CHECK_ENDPOINT}" | grep -q ${HEALTHY_RESPONSE_CONTAINS} || exit 1
