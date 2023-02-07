ARG PHP_VERSION=8
ARG SRC_IMAGE_TYPE="-fpm"
ARG CODEIGNITER_PACKAGE="appstarter"
FROM cloudyne.azurecr.io/php:${PHP_VERSION}${SRC_IMAGE_TYPE}

# Have nobody user install packages for compatibility
USER nobody

# Clear everything out of the folder at /app
# Then, install bedrock
ARG CODEIGNITER_PACKAGE
RUN rm -rf /app/* && \
    composer create-project codeigniter4/${CODEIGNITER_PACKAGE} /app
