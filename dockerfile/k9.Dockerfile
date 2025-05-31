FROM azul/zulu-openjdk-debian:8u452-jdk AS builder

WORKDIR /build

ARG K9_REPOSITORY="https://github.com/tterrag1098/K9.git"
ARG K9_COMMIT_HASH="633cb0a2b0ca191bf01e5d8f413348d715dda2cc"

RUN apt-get -qq update && \
    apt-get -qq -y install git && \
    git clone ${K9_REPOSITORY} ./ && \
    git checkout ${K9_COMMIT_HASH} && \
    ./gradlew assemble

FROM gcr.io/distroless/java21-debian12:nonroot

COPY --from=builder --chown=nonroot:nonroot /build/build/libs/*.jar /app/k9.jar

WORKDIR /app/data

CMD ["../k9.jar"]
