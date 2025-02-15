ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-cli
COPY --from=composer /usr/bin/composer /usr/bin/composer
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

COPY rootfs /

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed 's/memory_limit = 128M/memory_limit = 2G/' -i "$PHP_INI_DIR/php.ini"