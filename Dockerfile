FROM php:8.3-fpm

# setup general options for environment variables
ARG PHP_UPLOAD_MAX_FILESIZE_ARG="128M"

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

RUN echo "upload_max_filesize=${PHP_UPLOAD_MAX_FILESIZE}" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size=${PHP_UPLOAD_MAX_FILESIZE}" >> /usr/local/etc/php/conf.d/uploads.ini

WORKDIR /var/www/app

EXPOSE 9000
CMD ["php-fpm"]
