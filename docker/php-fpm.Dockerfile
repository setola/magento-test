ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions \
    bcmath \
    ctype \
    curl \
    dom \
    fileinfo \
    filter \
    gd \
    hash \
    iconv \
    intl \
    json \
    libxml \
    mbstring \
    openssl \
    pcre \
    pdo_mysql \
    simplexml \
    soap \
    sockets \
    sodium \
    tokenizer \
    xmlwriter \
    xsl \
    zip \
    zlib \
    libxml 
