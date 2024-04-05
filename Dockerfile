# Use the official PHP image with Apache
# You can choose the PHP version that matches your project's requirements
FROM wordpress:php8.0-apache

# Install additional dependencies if necessary
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    less \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install Composer
# Replace the version with the latest one or the one you need
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the Bedrock project files into the working directory
COPY . /var/www/html

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Adjust permissions
RUN chown -R www-data:www-data /var/www/html

# Use the default Apache configuration from the image
# You might need to customize this for your needs
COPY .docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
