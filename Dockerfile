FROM php:latest

# Install Git
RUN apt-get update && \
    apt-get install -y git



# Install Apache and PHP module
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-fcgid

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Enable PHP module and configure PHP file handling
RUN sed -i '/<IfModule mime_module>/a AddType application/x-httpd-php .php' /etc/apache2/apache2.conf && \
    sed -i 's/#AddHandler/LoadModule php_module modules\/libphp.so\nAddHandler php-script .php/' /etc/apache2/apache2.conf

# Update Apache configuration to allow .htaccess overrides
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
