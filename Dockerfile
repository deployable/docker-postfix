FROM debian:9

ARG DOCKER_BUILD_PROXY=

RUN set -uex;\
    http_proxy=$DOCKER_BUILD_PROXY apt-get update;\
    http_proxy=$DOCKER_BUILD_PROXY apt-get install -y postfix rsyslog curl procps less;

# Overlay
ENV OVERLAY_VERSION=v1.21.4.0
RUN set -uex; \
    curl --location https://github.com/just-containers/s6-overlay/releases/download/$OVERLAY_VERSION/s6-overlay-amd64.tar.gz.asc > /tmp/s6-overlay-amd64.tar.gz.asc; \
    curl --location https://github.com/just-containers/s6-overlay/releases/download/$OVERLAY_VERSION/s6-overlay-amd64.tar.gz > /tmp/s6-overlay-amd64.tar.gz; \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /; \
    rm -rf /tmp/*;


ADD overlay/ /

RUN set -uex; \
    useradd mattbcc; \
    useradd mattcc; \
    useradd matt

RUN set -uex; \
    chmod 755 /etc/services.d/*/run; \
    postconf -n; \
    postconf myhostname=postfixtest;  \
    postconf mydestination='$myhostname, /etc/mailname, localhost.localdomain, localhost';\
    sed -i -e 's/^#submission/submission/' /etc/postfix/master.cf; \
    sed -i -e 's/^#smtps/smtps/' /etc/postfix/master.cf; \
    sed -i -e 's/^#  -o syslog_name=postfix/  -o syslog_name=postfix/' /etc/postfix/master.cf; \
    postconf -Mf;\
    postconf -n;
    

#CMD ["/usr/lib/postfix/master", "-d"]
CMD ["/init"]

