FROM php:7.4.10-apache

RUN apt update
RUN apt install -y wget

COPY composer-setup.sh /tmp
RUN sh /tmp/composer-setup.sh
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

RUN apt install -y libzip-dev && docker-php-ext-install zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pdo_mysql
RUN printf "\n" | pecl install redis && docker-php-ext-enable redis
RUN apt install -y libmemcached-dev && printf "\n" | pecl install memcached && docker-php-ext-enable memcached
RUN apt install -y libpq-dev && docker-php-ext-install pdo_pgsql
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN printf "\n" | pecl install apcu && docker-php-ext-enable apcu

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

