ARG FROM=httpd:alpine
FROM ${FROM}

ARG FPM_URI=fcgi://php-fpm:9000
ENV FPM_URI=${FPM_URI}
ARG CERT_KEY=/usr/local/apache2/conf/server.key
ENV CERT_KEY=${CERT_KEY}
ARG CERT_FILE=/usr/local/apache2/conf/server.crt
ENV CERT_FILE=${CERT_FILE}
ARG PROXY_TIMEOUT=60
ENV PROXY_TIMEOUT=${PROXY_TIMEOUT}

ARG DEP_PACKAGES="shadow openssl"
RUN set -eux; \
  apk add -U --no-cache --virtual .persistent-deps-common ${DEP_PACKAGES}; \
  rm -rf /var/cache/apk/*

COPY rootfs /

RUN set -eux; \
  sed -i \
    -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_proxy_http.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_deflate.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_mime_magic.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_remoteip.so\)/\1/' \
    -e 's/^\(LoadModule .*mod_autoindex.so\)/#\1/' \
    -e 's/User daemon/User www-data/' \
    -e 's/Group daemon/Group www-data/' \
    -e 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' \
    -e '/<Directory "${HTTPD_PREFIX}\/htdocs">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' \
    -e 's/#ServerName.*/ServerName localhost:80/' \
    -e "\$aInclude conf/extra/docker-default.conf" \
    -e "\$aInclude conf/extra/remote-ip.conf" \
    "${HTTPD_PREFIX}/conf/httpd.conf"

RUN set -eux; \
  sed -i \
    -e 's/ServerName/#ServerName/' \
    -e 's/ServerAdmin/#ServerAdmin/' \
    "${HTTPD_PREFIX}/conf/extra/httpd-ssl.conf"

WORKDIR "${HTTPD_PREFIX}/htdocs"

VOLUME "${HTTPD_PREFIX}/htdocs"
VOLUME "${HTTPD_PREFIX}/certs"

EXPOSE 80 443
