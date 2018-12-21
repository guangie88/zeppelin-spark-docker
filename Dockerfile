ARG JAVA_VERSION=8
# FROM openjdk:${JAVA_VERSION}-jre-slim AS builder
FROM maven:3-jdk-${JAVA_VERSION}-slim AS builder

ARG ZEPPELIN_REV=master
ARG SCALA_VERSION=2.11

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y git ca-certificates

RUN set -eux; \
    git clone https://github.com/apache/zeppelin.git --depth 1 -b ${ZEPPELIN_REV}

RUN set -eux; \
    cd zeppelin; \
    ./dev/change_scala_version.sh ${SCALA_VERSION}

ARG SPARK_VERSION=
# ENV SPARK_VERSION=${SPARK_VERSION}

RUN set -eux; \
    echo ${SPARK_VERSION}; \
    mvn clean package -DskipTests -Pspark-${SPARK_VERSION:0:3} -Phadoop-2.7 -Pyarn -Ppyspark -Pscala-${SCALA_VERSION}

FROM guangie88/spark:${SPARK_VERSION}_java-${JAVA_VERSION}
