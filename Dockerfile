FROM scolagreco/docker-alpine:v3.9.2
MAINTAINER Stefano Colagreco <stefano@colagreco.it>

ENV JAVA_HOME=/opt/java/jdk
ENV PATH=$PATH:$JAVA_HOME/bin

RUN apk add --update --no-cache paxctl attr ca-certificates wget \
# GLIBC
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk \
 && apk add glibc-2.29-r0.apk \
 && mkdir -p /opt/java \
 && cd /opt/java \
# JAVA
 && wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz \
 && tar -zxvf jdk-8u201-linux-x64.tar.gz \
 && rm -Rf jdk-8u201-linux-x64.tar.gz \
 && mv jdk1.8.0_201 jdk \
 && echo "export JAVA_HOME=/opt/java/jdk" > /etc/profile.d/java.sh \
 && echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile.d/java.sh \
 && sh /etc/profile.d/java.sh \
 && cd /opt/java/jdk/bin \
 && setfattr -n user.pax.flags -v "mr" java \
 && setfattr -n user.pax.flags -v "mr" javac \
# ---
 && rm -Rf /glibc-2.29-r0.apk \
 && apk del paxctl attr ca-certificates wget 

# Metadata params
ARG BUILD_DATE
ARG VERSION="v1.8.0_201"
ARG VCS_URL="https://github.com/scolagreco/alpine-jdk.git"
ARG VCS_REF

# Metadata
LABEL maintainer="Stefano Colagreco <stefano@colagreco.it>" \
        org.label-schema.name="Alpine + Java (Oracle)" \
        org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.version=$VERSION \
        org.label-schema.vcs-url=$VCS_URL \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.description="Docker Image Alpine + Java (Oracle)"

CMD ["/bin/ash"]
