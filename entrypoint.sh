#!/bin/sh

echo "ifconfig lo 127.0.0.1"
ifconfig lo 127.0.0.1
echo "service ssh start"
service ssh start
sleep 5
echo "starting /vssh/socat"
/usr/bin/python3 /vssh/app.py
# /vssh/socat vsock-listen:2345,fork tcp4-connect:127.0.0.1:22
# java -Djava.security.egd=file:/dev/./urandom -jar /app/id-service-2.0.0-SNAPSHOT.jar