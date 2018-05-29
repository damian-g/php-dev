FROM damiang/php:latest

# Install
RUN apt-get update -qy && apt-get install -qy git-core \
    && cd /tmp/ && git clone -b xdebug_2_5 https://github.com/derickr/xdebug.git \
    && cd xdebug && phpize && ./configure --enable-xdebug && make \
    && mkdir /usr/lib/php5/ && cp modules/xdebug.so /usr/lib/php5/xdebug.so \
    && touch /usr/local/etc/php/ext-xdebug.ini \
    && rm -r /tmp/xdebug && apt-get purge -y git-core \
    && apt-get purge -y --auto-remove

# Configure
RUN printf "\nsendmail_path = /usr/sbin/ssmtp -t" >> /usr/local/etc/php/php.ini
RUN printf "\nerror_reporting = E_ALL|E_STRICT -t" >> /usr/local/etc/php/php.ini
COPY ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*
