FROM ubuntu:14.04
MAINTAINER Erik Zigo <erik@keboola.com>

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
      curl \
      wget \
      tar \
      openssl \
      git \
      php5 \
      php5-cli \
      php5-json \
      php5-mysqlnd

WORKDIR /home

# Initialize
COPY . /home/
RUN echo "memory_limit = -1" >> /etc/php.ini
RUN echo "date.timezone=UTC" >> /etc/php.ini
RUN echo "mysql.allow_local_infile = On" >> /etc/php.ini

RUN curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer

RUN composer install --no-interaction

RUN curl --location --silent --show-error --fail \
        https://github.com/Barzahlen/waitforservices/releases/download/v0.3/waitforservices \
        > /usr/local/bin/waitforservices && \
    chmod +x /usr/local/bin/waitforservices

ENTRYPOINT php ./src/run.php --data=/data