ARG TARGET_PHP_VERSION=7.2
FROM php:${TARGET_PHP_VERSION}-cli

ARG SERVICE_DIR="./workspace"
COPY ./scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# set timezone
ARG TZ=UTC
RUN /tmp/scripts/set_timezone.sh ${TZ}

# add users
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}

RUN /tmp/scripts/install_php_extensions.sh

RUN /tmp/scripts/install_software.sh


# Install composer and put binary into $PATH
RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/ \
  && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

ENV COMPOSER_MEMORY_LIMIT=-1

## NodeJS, NPM
# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# set up ssh
RUN apt-get update -yqq && apt-get install -yqq openssh-server \
 && mkdir /var/run/sshd \
;
#USER root
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
    && chmod 400 ~/.ssh/id_rsa \

# php config
#COPY ./config/php/conf.d/*  /usr/local/etc/php/conf.d/

# workdir
#ARG APP_CODE_PATH="/var/www"
#WORKDIR "$APP_CODE_PATH"

# entrypoint
#

#RUN /tmp/scripts/cleanup.sh

# @see https://docs.docker.com/engine/examples/running_ssh_service/
#CMD ["/usr/sbin/sshd", "-D"]
#ENTRYPOINT ["/bin/docker-entrypoint/resolve-docker-host-ip.sh"]

