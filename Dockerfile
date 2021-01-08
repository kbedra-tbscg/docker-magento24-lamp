# Docker LAMP Server
FROM debian:buster-20200908

# Base Packages
RUN apt-get update
RUN apt-get -y install git wget curl nano unzip sudo net-tools

# SSH
RUN echo 'root:toor' | chpasswd
RUN apt-get -y install openssh-server
#allow root login
COPY configs/sshd_config /etc/ssh/sshd_config

# Apache2
RUN apt-get -y install apache2
RUN service apache2 start
# Enable SSL and rewrite
RUN a2enmod rewrite
RUN a2enmod ssl
RUN mkdir /etc/apache2/ssl
COPY configs/openssl.key /etc/apache2/ssl/openssl.key
COPY configs/openssl.crt /etc/apache2/ssl/openssl.crt
COPY configs/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl.conf
# Create vhost magento.local
COPY configs/magento.local.conf /etc/apache2/sites-available/magento.local.conf
RUN a2ensite magento.local.conf
# Allow .htaccess files in /var/www
COPY configs/apache2.conf /etc/apache2/apache2.conf
RUN service apache2 restart
RUN chmod go-rwx /var/www/html
RUN chmod go+x /var/www/html

# PHP
RUN apt-get -y install php libapache2-mod-php php-gd php-mysql php-curl php-intl php-xsl php-mbstring php-bcmath php-xdebug php-soap php-imagick php-zip php-memcache
# Extend execution time from 30s to 300s
COPY configs/php.ini /etc/php/7.3/apache2/php.ini

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.17

# Copy Magento Repo Credentials
COPY configs/auth.json /root/.composer/auth.json

# Create magento project from composer
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.1 /var/www/html/magento

# Setup file permissions for magento
WORKDIR /var/www/html/magento
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
RUN find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
RUN chown -R :www-data .
RUN chmod u+x bin/magento


# Create run.sh file
RUN cd /sbin
RUN touch run.sh
RUN echo "#!/bin/bash" >> run.sh
RUN echo "service ssh start" >> run.sh
RUN echo "service apache2 start" >> run.sh
RUN chmod +x run.sh

# Start
EXPOSE 22 80 443
RUN service ssh start
#ENTRYPOINT ["./run.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]

