#!/bin/sh

chmod o+rx /var/lib/nginx
chmod og+rx /var/lib/nginx/tmp

addgroup -g ${GID} speedtest && \
adduser -h /speedtest -H -s /bin/sh -D -G speedtest -u ${UID} speedtest

chown -R speedtest:speedtest /speedtest/data
supervisord -c /usr/local/etc/supervisord.conf
