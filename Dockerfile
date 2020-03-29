FROM topaztechnology/sbt-java11-build:latest as build

COPY . /build

RUN \
  cd /build && \
  /usr/bin/sbt stage

FROM alpine:3.11.5

ENV APP_HOME /opt/app

RUN \
  mkdir -p $APP_HOME/lib

RUN apk add --update --no-cache openjdk11-jre-headless=11.0.5_p10-r0

COPY --from=build /build/target/universal/stage/lib/* $APP_HOME/lib/

ENTRYPOINT ["/usr/bin/java", "-cp", "/opt/app/lib/*", "com.topaz.azure.Program"]
