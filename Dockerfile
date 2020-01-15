FROM php:7.4-apache-buster

RUN apt-get update \ 
	&& apt-get install -y supervisor wait-for-it unzip git zlib1g-dev libzip-dev \
 	&& apt-get clean

RUN docker-php-ext-install pdo_mysql bcmath zip
RUN pecl install redis && docker-php-ext-enable redis
RUN pecl install xdebug && docker-php-ext-enable xdebug

ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

COPY php.ini /usr/local/etc/php/conf.d/app.ini

WORKDIR "/srv"
CMD ["wait-for-it", "rabbitmq:5672", "--", "supervisord", "-c", "supervisord.conf"]
