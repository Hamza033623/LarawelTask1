# Stage 1: Build (Composer and Dependencies Installation)
FROM composer:2 AS builder

# Set working directory
WORKDIR /app

# Copy composer files first to leverage Docker caching
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --ignore-platform-req=ext-ftp --ignore-platform-req=ext-gd --no-dev --optimize-autoloader --no-progress --no-scripts

# Copy the application source code
COPY . .

# Run any post-installation scripts (Autoload Optimization)
RUN composer dump-autoload --optimize

# Stage 2: Production Image (PHP with Apache)
FROM php:8.1-apache

# Install required extensions and tools, including MySQL client
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    curl \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip ftp \
    && a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy application files from the builder stage
COPY --from=builder /app /var/www/html

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]

