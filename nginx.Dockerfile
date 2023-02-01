ARG PHP_VERSION=8
ARG BUILD_ENV=production
ARG DEBUG_PACKAGES="nano bash net-tools wget"
FROM cloudyne.azurecr.io/php:${PHP_VERSION}-fpm

LABEL Maintainer="Cloudyne Systems"
LABEL Description="Lightweight PHP-FPM containers for Kubernetes based on Alpine Linux."
LABEL Version="1.0"

# Switch to root user for installation
USER root

# Add any debug packages specified
ARG BUILD_ENV
ARG DEBUG_PACKAGES
RUN if [ ${BUILD_ENV} = "debug" ]; then echo "Install debug packages: ${BUILD_ENV}" && apk add --no-cache ${DEBUG_PACKAGES}; fi

# Install the main package used for Nginx and Supervisor
RUN apk add --no-cache nginx supervisor

# Copy nginx config and set listener address to pass
ARG FPM_LISTENER
COPY assets/nginx.conf /etc/nginx/nginx.conf
RUN sed -i 's/fastcgi_pass .*/fastcgi_pass unix:\/run\/php-fpm.sock;/' /etc/nginx/nginx.conf

# Copy and configure FPM pool to listen on socket instead of IP
ARG PHP_VERSION
COPY assets/fpmpool.conf /etc/php${PHP_VERSION}/php-fpm.conf
RUN sed -i "s/0.0.0.0:8123/\/run\/php-fpm.sock/" /etc/php${PHP_VERSION}/php-fpm.conf

# Configure supervisord
COPY assets/supervisor.conf /etc/supervisor/conf.d/supervisord.conf
RUN sed -i "s/php-fpm8/php-fpm${PHP_VERSION}/" /etc/supervisor/conf.d/supervisord.conf

# Configure folder permissions
RUN chown -R nobody.nobody /app /run /var/www /var/lib/nginx /var/log/nginx

# Switch user back to nobody
USER nobody

# Expose nginx port
EXPOSE 8080

# Run the supervisor to start the services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Setup the healthchecks to ensure the container is health and responding
HEALTHCHECK --interval=5s --timeout=5s --start-period=15s --retries=3 CMD curl -sf http://127.0.0.1:8080/fpm-ping || exit 1

ENV APPLICATION_PATH=/app \
    WEBROOT_FOLDER=public \
    PHP_ADDITIONAL_PACKAGES="" \
    PHP_ADDITIONAL_OPTIONS="" \
    NGINX_WORKER_CONNECTIONS=1024 \
    NGINX_CUSTOM_5XX_ERROR_PAGE="" \
    INIT_COMMANDS=""
