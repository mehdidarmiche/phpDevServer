FROM php:7.2-fpm

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Locales
RUN apt-get update \
	&& apt-get install -y locales

### Create www-data ####################


ARG USER_ID=1000
ARG GROUP_ID=1000

RUN userdel -f www-data &&\
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -g www-data www-data 


RUN dpkg-reconfigure locales \
	&& locale-gen C.UTF-8 \
	&& /usr/sbin/update-locale LANG=C.UTF-8

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
	&& locale-gen

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Common
RUN apt-get update \
	&& apt-get install -y \
		openssl \
		git \
    gnupg2 \
		wget \
		libzip-dev \
		zip \
		unzip \
		cron


# PHP
# intl
RUN apt-get update \
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) intl

# xml
RUN apt-get update \
	&& apt-get install -y \
	libxml2-dev \
	libxslt-dev \
	&& docker-php-ext-install -j$(nproc) \
		dom \
		xmlrpc \
		xsl

# images
RUN apt-get update \
	&& apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	libgd-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) \
		gd \
		exif

# database
RUN docker-php-ext-install -j$(nproc) \
	mysqli \
	pdo \
	pdo_mysql

# strings
RUN docker-php-ext-install -j$(nproc) \
	gettext \
	mbstring

# math
RUN apt-get update \
	&& apt-get install -y libgmp-dev \
	&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
	&& docker-php-ext-install -j$(nproc) \
		gmp \
		bcmath

# compression
RUN apt-get update \
	&& apt-get install -y \
	libbz2-dev \
	zlib1g-dev \
	&& docker-php-ext-install -j$(nproc) \
		zip \
		bz2
RUN docker-php-ext-install json \
    && docker-php-ext-install opcache

# Install composer and put binary into $PATH
RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/ \
  && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

ENV COMPOSER_MEMORY_LIMIT=-1

## NodeJS, NPM
# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# Install wkhtmltopdf
RUN apt-get update \
  && apt-get install -y xvfb libfontconfig wkhtmltopdf




COPY .ssh/insecure_id_rsa /tmp/id_rsa
COPY .ssh/insecure_id_rsa.pub /tmp/id_rsa.pub

RUN rm -f /etc/service/sshd/down && \
    mkdir -p ~/.ssh/ \
    && touch ~/.ssh/authorized_keys \
    cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> ~/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> ~/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 ~/.ssh/authorized_keys ~/.ssh/id_rsa.pub \
    && chmod 600 ~/.ssh/id_rsa 


#### script alias ######################

COPY ./scripts/aliases.sh /root/aliases.sh
COPY ./scripts/aliases.sh /home/www-data/aliases.sh


RUN sed -i 's/\r//' /root/aliases.sh && \
    sed -i 's/\r//' /home/www-data/aliases.sh && \
    chown www-data:www-data /home/www-data/aliases.sh && \
    echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source ~/aliases.sh" >> ~/.bashrc && \
	  echo "" >> ~/.bashrc

#######################################

RUN git config --global user.email "mehdi.darmiche@gmail.com" && \
    git config --global user.name "Mehdi darmiche"

#### script alias ######################

# Create the log file
RUN touch /var/log/schedule.log
RUN chmod 0777 /var/log/schedule.log

COPY ./crontab/pushcrone /etc/cron.d/pushcrone

RUN crontab /etc/cron.d/pushcrone

########################################
# Clean
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

#!/bin/bash

WORKDIR "/var/www"

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh



