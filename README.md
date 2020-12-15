## php-nginx-alpine
Docker PHP + Nginx on Alpine Linux.

### Useage:

 1. docker build -t php-nginx-alpine:1.0 .
 2. docker run --rm --name php-nginx-alpine -d -p 80:8080 -p 443:8443 -v /var/www/html:/var/www/html php-nginx-alpine:1.0



