FROM lsiobase/nginx:3.12

LABEL description "audius Speedtest container. Based on LibreSpeed."
LABEL maintainer="Peter Schiek, Fabian Affolter"

ENV LIBRESPEED_RELEASE="5.2.2"

RUN \
  apk add --no-cache \
    curl \
    php7-gd \
    php7-mysqli \
    php7-pdo_pgsql \
    php7-pdo_sqlite && \
  if [ -z ${LIBRESPEED_RELEASE+x} ]; then \
    LIBRESPEED_RELEASE=$(curl -sX GET "https://api.github.com/repos/librespeed/speedtest/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p /usr/share/webapps/librespeed && \
  curl -o \
    /tmp/librespeed.tar.gz -L \
    "https://github.com/librespeed/speedtest/archive/${LIBRESPEED_RELEASE}.tar.gz" && \
  tar xf \
    /tmp/librespeed.tar.gz -C \
    /usr/share/webapps/librespeed --strip-components=1 && \
  sed -i -e 's/"LibreSpeed"/"audius Speedtest"/g' /usr/share/webapps/librespeed/results/index.php && \
  sed -i -e 's/LibreSpeed - Stats/audius Speedtest - Stats/g' /usr/share/webapps/librespeed/results/stats.php && \
  sed -i -e '51,53d' /usr/share/webapps/librespeed/speedtest.js && \
  rm -rf /tmp/*

# Add local files
COPY root/ /

# Ports and volumes
EXPOSE 80
VOLUME /config
