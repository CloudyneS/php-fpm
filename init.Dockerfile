# ARG PHP_VERSION=8
ARG INIT_PACKAGES='nano bash net-tools wget zip tar curl git p7zip python3 python3-pip python3-setuptools python3-dev'
# FROM cloudyne.azurecr.io/php:${PHP_VERSION}
FROM php:8.0.13-fpm-bullseye

# Switch to root user for configuration and installation
USER root

# Install init packages/tools
ARG INIT_PACKAGES
ENV PYTHONUNBUFFERED=1
# RUN apk add --update --no-cache ${INIT_PACKAGES}
RUN apt-get -y update && apt-get -y install ${INIT_PACKAGES}
# Add WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && \
    wp --info

# Upload init scripts and tools
RUN mkdir -p /init

WORKDIR /init

# Add tools for init
# ADD /assets/init/*.py /init/
ADD ./init-service .

# Install requirements
RUN pip3 --version && pip3 install --upgrade pip && pip3 install --upgrade -r /init/requirements.txt

# Change permissions and clean image
RUN chown -R nobody /init && \
    rm -rf /var/cache/apk/ 

# Switch back to nobody for container execution
USER nobody

CMD ["sh", "-c", "/usr/bin/python3 /init/controller.py"]


ENV RUN_COMPONENTS="filesystem/Filesystem:run"

ENV FS_CHECK_PATH="false" \
    FS_CHECK_PATH_TYPE="ANY" \
    FS_CHECK_ACTION_ONFAIL="FAIL" \
    FS_FILL_PATH="false" \
    FS_FILL_EMPTY_PATH_ONLY="true" \
    FS_FILL_PATH_FROM="git" \
    FS_FILL_PATH_DATA="https://github.com/nexB/extractcode" \
    FS_FILL_PATH_ONFAIL="FAIL" \
    FS_CLEANUP_ITEMS="/var/cache/apk"
