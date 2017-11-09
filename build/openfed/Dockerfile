FROM wodby/drupal-php:7.1-3.0.0

USER root

VOLUME /var/www/html

# COPY ./openfed.tar.gz .
# RUN tar -xzf openfed.tar.gz -C /usr/src/; \
#   rm openfed.tar.gz; \
#   mv /usr/src/openfed-* /usr/src/openfed; \
#   chown -R www-data:www-data /usr/src/openfed

WORKDIR /usr/src
RUN composer create-project openfed/openfed8-project:^1.0 openfed --no-interaction

WORKDIR /var/www/html
RUN chown -R www-data:www-data /usr/src/openfed
COPY .htaccess /usr/src/openfed/docroot

COPY docker-openfed-entrypoint.sh /docker-entrypoint-init.d/

USER www-data
