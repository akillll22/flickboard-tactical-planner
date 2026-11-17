# Laravel 11 Dockerfile
FROM php:8.3-cli-alpine

# Install system dependencies & PHP extensions for MySQL, BCMath, GD, Zip
RUN apk add --no-cache \
    curl \
    git \
    bash \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    mysql-client \
    && docker-php-ext-install pdo pdo_mysql bcmath gd zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Expose port 8000
EXPOSE 8000

CMD ["sh", "-c", "composer install --no-interaction && php artisan serve --host=0.0.0.0 --port=8000"]
