FROM php:8.1-apache
# Install dependencies
RUN apt-get update && apt-get upgrade -yy \
    && apt-get install --no-install-recommends apt-utils libjpeg-dev libpng-dev libwebp-dev \
    libzip-dev zlib1g-dev libfreetype6-dev supervisor zip \
    unzip software-properties-common -yy \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install required PHP extensions
RUN docker-php-ext-install zip \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-install exif \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j "$(nproc)" gd \
    && a2enmod rewrite

# # Update Apache port configuration
# RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
# RUN sed -i 's/:80/:8080/' /etc/apache2/sites-available/000-default.conf

# Expose port 8080
EXPOSE 80

WORKDIR /var/www/html
COPY . /var/www/html/
RUN chown -R www-data: /var/www/html/

# # Copy the entrypoint script
# COPY entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/entrypoint.sh

# # Set the entrypoint script as the container's entrypoint
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

