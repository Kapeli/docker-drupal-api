FROM drupal:11-php8.3-apache

VOLUME /opt/drupal/code

# Env for docker-compose
ENV REPO_DIR=/opt/drupal/code

# Copy install requirements
COPY .docker/web.entrypoint.sh /entrypoint.sh


# All run actions in one layer.
RUN apt update && apt install -y -qq bash git curl wget tar zip unzip gzip mariadb-client && \
  rm -r /var/lib/apt/lists/* && \
  echo 'output_buffering = On' >> /usr/local/etc/php/conf.d/docker-php-output.ini && \
  echo 'memory_limit = 2048M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini && \
  echo 'error_reporting = E_ALL & ~E_DEPRECATED' >> /usr/local/etc/php/conf.d/docker-php-errors.ini && \
  yes | composer require 'nikic/php-parser:^4|^5' 'drupal/api:2.x-dev@dev' 'drush/drush' --no-interaction --prefer-dist  && \
  yes | composer install && \
  ln -s /opt/drupal/vendor/bin/drush /usr/local/bin/drush && \
  mkdir -p $REPO_DIR && \
  chmod +x /entrypoint.sh

CMD /entrypoint.sh