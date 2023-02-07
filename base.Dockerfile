ARG ALPINE_VERSION=3.17
ARG PHP_VERSION=8
ARG FPM_LISTENER="0.0.0.0:8123"
FROM alpine:${ALPINE_VERSION}

LABEL Maintainer="Cloudyne Systems"
LABEL Description="Lightweight PHP-FPM containers for Kubernetes based on Alpine Linux."
LABEL Version="1.0"

# Set the working directory to /app and install application packages
WORKDIR /app
RUN mkdir -p /app/public

# Add package repositories and update
ADD assets/apk.conf /etc/apk/repositories
RUN apk update

# Install PHP and additional packages
ARG PHP_VERSION
RUN apk add --no-cache \
    curl msmtp curl git \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-xmlreader \
    php${PHP_VERSION}-xmlwriter \
    php${PHP_VERSION}-sqlite3 \
    php${PHP_VERSION}-simplexml
    
# Add composer
ARG ADD_COMPOSER
RUN curl -sS https://getcomposer.org/installer | php${PHP_VERSION} -- --install-dir=/usr/local/bin --filename=composer; 

# Copy and configure FPM Pool
ARG FPM_LISTENER
COPY assets/fpmpool.conf /etc/php${PHP_VERSION}/php-fpm.conf
RUN sed -i "s/0.0.0.0:8123/${FPM_LISTENER}/" /etc/php${PHP_VERSION}/php-fpm.conf

# Add sample index.php file to webroot
COPY assets/index.php /app/public/index.php

# Ensure the files and folders needed by the processes are accessible to a normal user
# and that the supervisord file has the correct PHP version. Also link php to php[version]
# for apps that require it (like composer)
ARG PHP_VERSION
RUN chown -R nobody.nobody /app /var/log/php${PHP_VERSION} && \
    ln -sf /usr/bin/php${PHP_VERSION} /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm${PHP_VERSION} /start

# Switch to a non-root user
USER nobody

# Expose the FPM listen port
EXPOSE 8123

# Run the supervisor to start the services
CMD ["/start", "-F"]

ENV APPLICATION_PATH=/app
