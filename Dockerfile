# ICEfaces "Auction Monitor" (Ajax Push sample) – built from source, run on Tomcat 9 + Java 8

# ---- build stage ----
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /app
COPY pom.xml build.sh ./
COPY src ./src
RUN sh build.sh

# ---- run stage ----
FROM tomcat:9.0-jdk8-temurin
RUN rm -rf /usr/local/tomcat/webapps/* \
 && mkdir -p /usr/local/tomcat/webapps/ROOT \
 && printf '<!doctype html><meta http-equiv="refresh" content="0;url=/auctionMonitor/"><a href="/auctionMonitor/">Auction Monitor demo</a>\n' \
      > /usr/local/tomcat/webapps/ROOT/index.html

# Behind a TLS-terminating proxy (Render etc.): trust X-Forwarded-Proto so redirects stay on https
RUN sed -i 's#</Host>#  <Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="x-forwarded-proto" />\n      </Host>#' \
      /usr/local/tomcat/conf/server.xml

COPY --from=build /app/target/auctionMonitor.war /usr/local/tomcat/webapps/auctionMonitor.war

# Fit in a 512 MB free instance
ENV CATALINA_OPTS="-Xms128m -Xmx300m -XX:MaxMetaspaceSize=160m -XX:+UseSerialGC -Djava.security.egd=file:/dev/./urandom"

EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]
