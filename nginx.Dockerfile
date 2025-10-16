FROM nginx:1.24.0-alpine

WORKDIR /var/www

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.
RUN apk update \
    && apk upgrade \
    && apk add --no-cache openssl \
    && apk add --no-cache bash \
    && apk add --no-cache openssh \
    && apk add --no-cache logrotate \
    && adduser -D -H -u 1000 -s /bin/bash -Gwww-data www-data

ARG FRONTEND_UPSTREAM_CONTAINER=frontend
ARG FRONTEND_UPSTREAM_PORT=3000

ARG PHP_UPSTREAM_CONTAINER=app
ARG PHP_UPSTREAM_PORT=9000

ARG WEBSOCKET_UPSTREAM_CONTAINER=app
ARG WEBSOCKET_UPSTREAM_PORT=6001

# Set upstream conf and remove the default conf
RUN echo "upstream frontend-upstream { server ${FRONTEND_UPSTREAM_CONTAINER}:${FRONTEND_UPSTREAM_PORT}; }" >> /etc/nginx/conf.d/upstream.conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" >> /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf

COPY ./docker/nginx/startup.sh /opt/startup.sh

COPY docker/nginx/nginx.conf /etc/nginx/
RUN mkdir -p /etc/nginx/sites-available/
COPY docker/nginx/ssl/ /etc/nginx/ssl/

COPY --chown=docker:docker public .

RUN sed -i 's/\r//g' /opt/startup.sh
CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 80 443
