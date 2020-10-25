FROM alpine:3.12.1

LABEL description "audius Speedtest container. Based on LibreSpeed."
LABEL maintainer="Peter Schiek, Fabian Affolter"

ENV LIBRESPEED_RELEASE="5.2.2"
ENV S6RELEASE="v2.0.0.1"
ENV S6URL="https://github.com/just-containers/s6-overlay/releases/download/"
ENV S6_READ_ONLY_ROOT=1

RUN \
# Install dependencies
    apk add --no-cache gnupg nginx php7-fpm php7-json php7-gd \
        php7-opcache php7-pdo_mysql php7-pdo_pgsql php7-mysqli tzdata \
    && apk upgrade --no-cache \
# Remove (some of the) default nginx config
    && rm -f /etc/nginx.conf /etc/nginx/conf.d/default.conf /etc/php7/php-fpm.d/www.conf \
    && rm -rf /etc/nginx/sites-* \
# Ensure nginx logs, even if the config has errors, are written to stderr
    && ln -s /dev/stderr /var/log/nginx/error.log
# Install Librespeed
RUN \
    rm -rf /var/www/* \
    && cd /tmp \
    && wget -q https://github.com/librespeed/speedtest/archive/${LIBRESPEED_RELEASE}.tar.gz \
    && cd /var/www \
    && tar -xzf /tmp/${LIBRESPEED_RELEASE}.tar.gz --strip 1 \
    && mv backend results /srv \
    && mkdir -p /srv/data
# Install s6 overlay for service management
RUN \
  wget -qO - https://keybase.io/justcontainers/key.asc | gpg2 --import - \
  && cd /tmp \
  && S6ARCH=$(uname -m) \
  && case ${S6ARCH} in \
         x86_64) S6ARCH=amd64;; \
         armv7l) S6ARCH=armhf;; \
     esac \
  && wget -q ${S6URL}${S6RELEASE}/s6-overlay-${S6ARCH}.tar.gz.sig \
  && wget -q ${S6URL}${S6RELEASE}/s6-overlay-${S6ARCH}.tar.gz \
  && gpg2 --verify s6-overlay-${S6ARCH}.tar.gz.sig \
  && tar -xzf s6-overlay-${S6ARCH}.tar.gz -C / \
# Support running s6 under a non-root user
  && mkdir -p /etc/services.d/nginx/supervise /etc/services.d/php-fpm7/supervise \
  && mkfifo \
      /etc/services.d/nginx/supervise/control \
      /etc/services.d/php-fpm7/supervise/control \
      /etc/s6/services/s6-fdholderd/supervise/control \
  && adduser nobody www-data \
  && chown -R nobody.www-data /etc/services.d /etc/s6 /run /srv/* /var/lib/nginx /var/www \
# Clean up
    && rm -rf "${GNUPGHOME}" /tmp/* \
    && apk del gnupg

COPY etc/ /etc/

COPY index.html /var/www

WORKDIR /var/www
# user nobody, group www-data
USER 65534:82

# Mark dirs as volumes that need to be writable, allows running the container --read-only
VOLUME /run /srv/data /tmp /var/lib/nginx/tmp

EXPOSE 8080

ENTRYPOINT ["/init"]
