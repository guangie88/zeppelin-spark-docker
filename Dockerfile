ARG JAVA_VERSION=8
# FROM openjdk:${JAVA_VERSION}-jre-slim AS builder
FROM maven:3-jdk-${JAVA_VERSION}-slim AS builder

ARG ZEPPELIN_REV=master
ARG SCALA_VERSION=2.11

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y git ca-certificates

RUN set -eux; \
    git clone https://github.com/apache/zeppelin.git -b ${ZEPPELIN_REV}

RUN set -eux; \
    cd zeppelin; \
    ./dev/change_scala_version.sh ${SCALA_VERSION}

ARG SPARK_VERSION=
# ENV SPARK_VERSION=${SPARK_VERSION}

ARG ZEPPELIN_SPARK_VERSION=2.0
ARG ZEPPELIN_HADOOP_VERSION=2.4

RUN set -eux; \
    echo ${SPARK_VERSION}; \
    SPARK_NO_PATCH_VERSION=$(echo ${SPARK_VERSION} | sed -E 's/([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)/\1.\2/g'); \
    cd zeppelin; \
    mvn clean package -DskipTests -Pspark-${ZEPPELIN_SPARK_VERSION} -Phadoop-${ZEPPELIN_HADOOP_VERSION} -Pscala-${SCALA_VERSION}

FROM guangie88/spark:${SPARK_VERSION}_java-${JAVA_VERSION}
