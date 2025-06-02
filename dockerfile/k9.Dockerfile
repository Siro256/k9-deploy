FROM azul/zulu-openjdk-debian:11.0.27-jdk AS builder

WORKDIR /build

ARG K9_REPOSITORY="https://github.com/Siro256/K9.git"
ARG K9_COMMIT_HASH="4d5e91bdff969c875ab68b782c1dd092560b2ee1"

RUN apt-get -qq update && \
    apt-get -qq -y install git && \
    git clone ${K9_REPOSITORY} ./ && \
    git checkout ${K9_COMMIT_HASH} && \
    chmod +x gradlew && \
    ./gradlew shadowJar

FROM gcr.io/distroless/java21-debian12:nonroot

COPY --from=builder --chown=nonroot:nonroot /build/build/libs/*.jar /app/k9.jar

WORKDIR /app/data

CMD ["../k9.jar"]
