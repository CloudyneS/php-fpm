ARG PHP_VERSION=8
ARG SRC_IMAGE_TYPE=fpm
FROM cloudyne.azurecr.io/php:${PHP_VERSION}-${SRC_IMAGE_TYPE}

# Switch to root user for configuration and installation
USER root

# Add WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && \
    wp --info

# Replace folder for nginx to listen to
RUN if [ ${ADD_COMPOSER} = "true" ]; then \
    sed -i "s/root \/app\/public/root \/app\/web/" /etc/nginx/nginx.conf; fi && apk add --no-cache mariadb-client

# Switch back to nobody to install Bedrock
USER nobody

# Clear everything out of the folder at /app
# Then, install bedrock
RUN rm -rf /app/* && \
    composer create-project roots/bedrock /app
