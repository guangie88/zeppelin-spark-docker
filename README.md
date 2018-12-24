# Zeppelin Spark Docker

Dockerfile setup for Zeppelin with custom Spark built-in

## Example build command

```bash
JAVA_VERSION=8 SPARK_VERSION=2.3.1 && \
    TAG_NAME="${SPARK_VERSION}_java-${JAVA_VERSION}" && \
    docker build . -t guangie88/zeppelin-spark:${TAG_NAME} \
        --build-arg JAVA_VERSION=${JAVA_VERSION} \
        --build-arg SPARK_VERSION=${SPARK_VERSION} \
        --build-arg ZEPPELIN_REV=0.8.0
```
