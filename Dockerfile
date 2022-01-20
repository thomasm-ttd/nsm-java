# FROM rust:1.43 as jnsm_builder
# COPY ./jnsm /
# WORKDIR /jnsm
# RUN cargo build --lib --release


FROM maven:3.6.0-jdk-8 AS java_builder
WORKDIR /
COPY attestation-aws /attestation-aws
COPY example /example
COPY build.sh /
RUN chmod +x /build.sh
RUN /build.sh

ARG LIB_VERSION=1.0.0-SNAPSHOT

WORKDIR /attestation-aws
RUN mvn package
RUN mvn deploy:deploy-file -Durl=file:///example/repo -Dfile="/attestation-aws/target/attestation-aws-${LIB_VERSION}.jar" -DgroupId='com.uid2' -DartifactId='attestation-aws' -Dpackaging=jar -Dversion=${LIB_VERSION}
WORKDIR /example
RUN mvn clean compile assembly:single


FROM ubuntu:18.04
ARG JAR_VERSION=1.0.0-SNAPSHOT
ENV JAR_VERSION=${JAR_VERSION}
ARG LIB_VERSION=1.0.0-SNAPSHOT

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/app/lib
WORKDIR /
RUN mkdir app
COPY --from=java_builder /example/repo /app/repo
COPY --from=java_builder /example/target/* /app/
#COPY --from=jnsm_builder /jnsm/target/release/libjnsm.so /app/lib/
COPY ./jnsm/target/release/libjnsm.so /app/lib/

# -- setup for vssh -- #
COPY vssh /vssh
RUN apt update && apt install python3 -y && apt install openjdk-8-jre-headless -y
RUN apt install net-tools iputils-ping openssh-server sudo -y
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test
RUN echo 'test:test' | chpasswd
RUN mkdir /home/ubuntu/.ssh
RUN cat /vssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
# -- finish setting up for vssh -- #

COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]