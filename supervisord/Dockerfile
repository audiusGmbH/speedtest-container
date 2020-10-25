FROM alpine:latest

LABEL description "PrivateBin is a minimalist, open source online pastebin where the server has zero knowledge of pasted data."
LABEL maintainer="Peter Schiek, Fabian Affolter"

ARG VERSION=1.3.4
ARG LIBRESPEED_RELEASE=5.2.2
ARG BUILD_DATE=20201025
ARG VERSION=1.0.0

ENV GID=991 UID=991

RUN \
  apk -U add --no-cache \
    curl \
    nginx \
    php7-fpm \
    php7-gd \
    php7-json \
	php7-mysqli \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    supervisor \
    ca-certificates \
    tar
RUN \
 if [ -z ${LIBRESPEED_RELEASE+x} ]; then \
	LIBRESPEED_RELEASE=$(curl -sX GET "https://api.github.com/repos/librespeed/speedtest/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi \
 && mkdir -p /var/www \
 && mkdir -p privatebin/data \
 && curl -o \
	/tmp/librespeed.tar.gz -L \
	"https://github.com/librespeed/speedtest/archive/${LIBRESPEED_RELEASE}.tar.gz" \
 && tar xf \
	/tmp/librespeed.tar.gz -C \
	/var/www --strip-components=1 \
 && rm -rf /tmp/*

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/php-fpm.conf /etc/php7/php-fpm.conf
COPY files/supervisord.conf /usr/local/etc/supervisord.conf
COPY index.html /var/www/
COPY logo.png /var/www/
COPY entrypoint.sh /

# Mark dirs as volumes that need to be writable, allows running the container --read-only
VOLUME [ "/speedtest/data", "/etc", "/tmp", "/var/lib/nginx/tmp", "/run", "/var/log" ]

EXPOSE 80

CMD ["/entrypoint.sh"]
