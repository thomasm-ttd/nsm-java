#!/bin/sh

LIBVER=1.0.0-SNAPSHOT

# cd jnsm
# cargo build --lib
cd /attestation-aws
mvn package
mvn deploy:deploy-file -Durl=file:///example/repo -Dfile="/attestation-aws/target/attestation-aws-$LIBVER.jar" -DgroupId='com.uid2' -DartifactId='attestation-aws' -Dpackaging=jar -Dversion=$LIBVER
cd /example
mvn package
