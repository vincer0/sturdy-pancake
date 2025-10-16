#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM phusion/baseimage:noble-1.0.2

RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM=xterm

# Add the "PHP 7" ppa
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#

ARG DEPLOY_PHP_VERSION=8.3

# Install "PHP Extentions", "libraries", "Software's"
RUN set -xe; \
    apt-get update -yqq && \
    apt-get upgrade -y -o DPkg::Options::=--force-confdef  && \
    apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        php${DEPLOY_PHP_VERSION}-cli \
        php${DEPLOY_PHP_VERSION}-fpm \
        php${DEPLOY_PHP_VERSION}-common \
        php${DEPLOY_PHP_VERSION}-curl \
        php${DEPLOY_PHP_VERSION}-intl \
        php${DEPLOY_PHP_VERSION}-mbstring \
        php${DEPLOY_PHP_VERSION}-mysql \
        php${DEPLOY_PHP_VERSION}-zip \
        php${DEPLOY_PHP_VERSION}-bcmath \
        php${DEPLOY_PHP_VERSION}-memcached \
        php${DEPLOY_PHP_VERSION}-gd \
        php${DEPLOY_PHP_VERSION}-dev \
        php${DEPLOY_PHP_VERSION}-mysqli \
        php${DEPLOY_PHP_VERSION}-pdo \
        php${DEPLOY_PHP_VERSION}-tokenizer \
        php${DEPLOY_PHP_VERSION}-xml \
        php${DEPLOY_PHP_VERSION}-imagick \
        php${DEPLOY_PHP_VERSION}-zip \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        git \
        rsync \
        wget \
        curl \
        vim \
        supervisor \
        libmemcached-dev \
        libmcrypt-dev \
        zlib1g-dev \
        autoconf \
        libpng16-16 \
        jpegoptim \
        optipng \
        pngquant \
        gifsicle \
        libpng-dev \
        libwebp-dev \
        webp \
        imagemagick \
        apt-utils \
        libzip-dev zip unzip \
        nano \
        php -m | grep -q 'zip' \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /var/log/lastlog /var/log/faillog

### Setup redis
RUN update-alternatives --set php /usr/bin/php${DEPLOY_PHP_VERSION}
RUN pecl install redis

#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ENV PUID=${PUID}
ARG PGID=1000
ENV PGID=${PGID}

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=UTC
ENV TZ=${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###########################################################################
# User Aliases
###########################################################################

USER root

COPY docker/app/aliases.sh /root/aliases.sh
COPY docker/app/aliases.sh /home/ubuntu/aliases.sh

RUN sed -i 's/\r//' /root/aliases.sh && \
    sed -i 's/\r//' /home/ubuntu/aliases.sh && \
    chown ubuntu:ubuntu /home/ubuntu/aliases.sh && \
    echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source ~/aliases.sh" >> ~/.bashrc && \
	  echo "" >> ~/.bashrc

USER ubuntu

RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source ~/aliases.sh" >> ~/.bashrc && \
	  echo "" >> ~/.bashrc

###########################################################################
# Composer:
###########################################################################

USER root

# Add the composer.json
COPY docker/app/composer.json /home/ubuntu/.composer/composer.json

# assign everything to docker user in home/docker
RUN mkdir -p /home/ubuntu/.ssh
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN chown -R ubuntu:ubuntu /home/ubuntu/.ssh

RUN mkdir -p /home/ubuntu/.composer

# Make sure that ~/.composer belongs to docker
RUN chown -R ubuntu:ubuntu /home/ubuntu/.composer

USER ubuntu

# run the install
RUN composer global install

# remove the file
# rm /home/ubuntu/.composer/auth.json

# Export composer vendor path
RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc

###########################################################################
# Non-root user : PHPUnit path
###########################################################################

# add ./vendor/bin to non-root user's bashrc (needed for phpunit)
USER ubuntu

RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="/var/www/vendor/bin:$PATH"' >> ~/.bashrc

###########################################################################
# Crontab
###########################################################################

USER root

COPY docker/app/crontab /etc/cron.d

RUN chmod -R 644 /etc/cron.d

USER root

RUN exec bash && . ~/.bashrc && npm install -g svgo

###########################################################################
# Supervisor:
###########################################################################

USER root

COPY docker/app/supervisord.conf /etc/supervisord.conf
COPY docker/php-fpm/laravel.ini /etc/php/${DEPLOY_PHP_VERSION}/fpm/conf.d/99-laravel.ini
COPY docker/php-fpm/xlaravel.pool.conf /etc/php/${DEPLOY_PHP_VERSION}/fpm/pool.d/www.conf
COPY docker/app/entrypoint_v2.sh /usr/local/bin/docker-entrypoint
COPY docker/app/supervisord.d/laravel-horizon.conf.example /etc/supervisord.d/laravel-horizon.conf
COPY docker/app/supervisord.d/laravel-scheduler.conf.example /etc/supervisord.d/laravel-scheduler.conf
COPY docker/app/supervisord.d/laravel-phpfpm.conf.example /etc/supervisord.d/laravel-phpfpm.conf
COPY docker/app/supervisord.d/*.conf /etc/supervisord.d/
RUN mkdir -p /run/php && chmod 777 /run/php
RUN echo 'extension=redis.so' >> /etc/php/${DEPLOY_PHP_VERSION}/cli/php.ini
RUN echo 'extension=redis.so' >> /etc/php/${DEPLOY_PHP_VERSION}/fpm/php.ini

RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
EXPOSE 9000 6001

###########################################################################
# Setup all the data & install deps
###########################################################################

USER root
WORKDIR /var/www
RUN chown -R ubuntu:ubuntu /var/www

USER ubuntu
WORKDIR /var/www

COPY --chown=ubuntu:ubuntu . .

RUN composer install --optimize-autoloader

