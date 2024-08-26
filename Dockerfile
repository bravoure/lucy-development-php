FROM php:8.3-fpm

# setup general options for environment variables
ARG PHP_MEMORY_LIMIT_ARG="256M"
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT_ARG}
ARG PHP_MAX_EXECUTION_TIME_ARG="120"
ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME_ARG}
ARG PHP_UPLOAD_MAX_FILESIZE_ARG="128M"
ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE_ARG}
ARG PHP_MAX_INPUT_VARS_ARG="1000"
ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS_ARG}
ARG PHP_POST_MAX_SIZE_ARG="128M"
ENV PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE_ARG}

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    zip \
    unzip \
    curl \
    git \
    imagemagick \
    libgd-dev

# Install GD extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install other PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath zip intl soap gd

# Create a generic non-root user
RUN useradd -ms /bin/bash appuser

# Create the working directory and set permissions
RUN mkdir -p /var/www/app && chown -R appuser:appuser /var/www/app

# switch to non-root user
USER appuser

# copy generic ini settings
COPY --chown=appuser:appuser php-custom.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/backend

EXPOSE 9000
CMD ["php-fpm"]
