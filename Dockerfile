FROM alpine:3.12
MAINTAINER Ximin Zhang <zhangximin@gmail.com>
LABEL maintainer="Ximin Zhang <zhangximin@gmail.com>"

RUN sed -i "s@http://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories && \
    apk --no-cache add php7 php7-fpm php7-opcache php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd nginx supervisor curl openssl && \
    rm /etc/nginx/conf.d/default.conf && \
    mkdir -p /var/www/html && \
    openssl req -x509 -nodes -days 3650 \
    -subj  "/C=CN/ST=Beijing/L=Chaoyang/O=Tiertime Inc/CN=tiertime.com" \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt && \
    openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096 && \
    chown -R nobody.nobody /var/www/html && \
    chown -R nobody.nobody /run && \
    chown -R nobody.nobody /var/lib/nginx && \
    chown -R nobody.nobody /var/log/nginx && \
    chown nobody.nobody /etc/ssl/private/nginx-selfsigned.key && \
    chown nobody.nobody /etc/ssl/certs/nginx-selfsigned.crt

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf
COPY config/options-ssl-nginx.conf /etc/nginx/

COPY config/php-fpm.conf /etc/php7/
COPY config/www.conf /etc/php7/php-fpm.d/www.conf

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER nobody

EXPOSE 8080 8443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping

