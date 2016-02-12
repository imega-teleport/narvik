FROM alpine:3.3

EXPOSE 9000

RUN apk add --update \
        php-fpm \
        php-openssl \
        ca-certificates && \
    mkdir -p /tmp/nginx/client-body && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/php-fpm.conf && \
    sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php/php-fpm.conf && \
    sed -i 's/html_errors = On/html_errors = Off/g' /etc/php/php.ini && \
    sed -i 's/;php_flag\[display_errors\]/php_flag\[display_errors\]/g' /etc/php/php-fpm.conf && \
    sed -i 's/listen.allowed_clients = 127.0.0.1/;listen.allowed_clients = 127.0.0.1/g' /etc/php/php-fpm.conf && \
    rm -rf /var/cache/apk/*

COPY . /

WORKDIR /app

ENTRYPOINT ["/bin/sh", "/entry.sh"]

CMD ["php-fpm", "-F"]
