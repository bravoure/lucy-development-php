FROM php:8.3-fpm

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

WORKDIR /var/www/app

EXPOSE 9000
CMD ["php-fpm"]
