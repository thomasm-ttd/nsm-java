FROM ubuntu:18.04

RUN apt update -y && apt install python3 -y
RUN apt install net-tools iputils-ping openssh-server sudo -y
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test
RUN mkdir /home/ubuntu/.ssh
RUN echo 'test:test' | chpasswd

# COPY libnsm.so /usr/lib64/libnsm.so
# COPY kmstool_enclave_cli /kmstool_enclave_cli
COPY *.py /app/
COPY socat /app/
COPY id_rsa.pub /app/
COPY entrypoint.sh /app/

RUN chmod +x /app/socat
RUN chmod +x /app/entrypoint.sh
RUN cat /app/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys

WORKDIR /app

CMD ["/app/entrypoint.sh"]