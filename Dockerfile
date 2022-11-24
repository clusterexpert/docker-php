FROM php:7.4-cli-buster

RUN apt-get update \ 
	&& apt-get install -y supervisor wait-for-it unzip git zlib1g-dev libzip-dev zip lighttpd \
 	&& apt-get clean

RUN docker-php-ext-install pdo_mysql bcmath zip
RUN pecl install redis && docker-php-ext-enable redis
RUN pecl install xdebug && docker-php-ext-enable xdebug

ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

COPY php.ini /usr/local/etc/php/conf.d/app.ini

RUN lighttpd-enable-mod rewrite fastcgi-php
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
RUN sed -i 's#/usr/bin/php-cgi#/usr/local/bin/php-cgi#g' /etc/lighttpd/conf-available/15-fastcgi-php.conf
RUN echo 'url.rewrite-if-not-file = ( "/\??(.*)$" => "/index.php?$1", )' >> /etc/lighttpd/conf-enabled/10-rewrite.conf
RUN mkdir /var/run/lighttpd && chown www-data: /var/run/lighttpd

WORKDIR "/srv"
CMD ["wait-for-it", "rabbitmq:5672", "--", "supervisord", "-c", "/srv/supervisord.conf"]

# supervisor gui
EXPOSE 9001
