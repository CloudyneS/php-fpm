ARG PHP_VERSION=8
ARG INIT_PACKAGES='nano bash net-tools wget python3 py3-pip py3-setuptools'
FROM cloudyne.azurecr.io/php:${PHP_VERSION}

# Switch to root user for configuration and installation
USER root

# Install init packages/tools
ARG INIT_PACKAGES
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache ${INIT_PACKAGES}

# Add WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && \
    wp --info

# Upload init scripts and tools
RUN mkdir -p /init

# Add tools for init
ADD /assets/init/*.py /init/

# Change permissions and clean image
RUN chown -R nobody.nobody /init && \
    rm -rf /var/cache/apk/ 

# Switch back to nobody for container execution
USER nobody

CMD ["sh", "-c", "/usr/bin/python3 /init/controller.py"]
    
    # MySQL Connection string for database connection
ENV DB_CONNECTION_STRING="" \
    # Check if above credentials can make a connection to DB (false or DB Name)
    DB_CHECK_LOGIN="false" \
    # Exit if database doesn't exist
    DB_EXIT_ONFAIL_CHECK_LOGIN="false" \
    # Try creating the database if it doesn't exist
    DB_CREATE_ONFAIL_CHECK_TABLE="false" \
    # Check if the specified table exists (false or Table name)
    DB_CHECK_TABLE="false" \
    # Exit if table doesn't exist
    DB_EXIT_ONFAIL_CHECK_TABLE="false" \
    # If table check fails, upload a file (false or path to file)
    DB_INSERT_ONFAIL_CHECK_TABLE="false" \
    #
    # Composer
    # Run Composer
    COMPOSER_RUN="false" \
    # Run Composer Command
    COMPOSER_RUN_COMMAND="install" \
    # Composer.json file path
    COMPOSER_RUN_FILE_PATH="/app/composer.json" \
    # Args to pass to composer
    COMPOSER_RUN_ARGS="--no-dev" \
    # Exit on failure
    COMPOSER_EXIT_ONFAIL="true" \
    #
    # WP-CLI/Bedrock/Wordpress
    # Path to app root for Wordpress/Bedrock
    WP_CONFIG_PATH="/app" \
    # Check if the database is a valid Wordpress database
    WP_CHECK_DB_WORKS="false" \
    # Exit if connection check fails
    WP_EXIT_ONFAIL_CHECK_DB_WORKS="false" \
    # Import file if check fails (false or path to file)
    WP_IMPORT_ONFAIL_CHECK_DB_WORKS="false" \
    #
    # Codeigniter
    # Codeigniter base path
    CI_BASE_PATH="" \
    # Create migrations for Codeigniter
    CI_MAKE_MIGRATIONS="false" \
    # Apply migrations for Codeigniter
    CI_DO_MIGRATIONS="false" \
    # Exit if any of the CI jobs fail
    CI_EXIT_ONFAIL_MIGRATIONS="false"