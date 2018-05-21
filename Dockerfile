FROM ubuntu:1404-163
MAINTAINER qiang <194724379@qq.com>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
	apache2 \
        libapache2-mod-php5 \
        freetds-common \
	freetds-dev \
	freetds-bin \
        php5-fpm \
	php5-sybase \
        php5-mysql \
        php5-gd \
        php5-curl \
        php5-memcache \
	php5-dev \
        php-pear \
	&& \
    rm -rf /var/lib/apt/lists/*
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf 

ENV ALLOW_OVERRIDE **True**

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

#vhost
ADD vhost.conf /etc/apache2/sites-available/vhost.conf
ADD apache2.conf /etc/apache2/apache2.conf
RUN a2enmod vhost_alias
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN a2ensite vhost

# Configure /data folder with sample app
RUN mkdir -p /data && rm -fr /var/www/html && ln -s /data /var/www/html
#ADD sample/ /data

VOLUME  ["/etc/apache2"]

#php config#####################################
#compile amqp
ADD soft/amqp-1.7.1.tgz /tmp/
ADD soft/rabbitmq-c-0.8.0.tar.gz /tmp/

WORKDIR /tmp/rabbitmq-c-0.8.0
RUN	./configure --prefix=/usr/local/rabbitmq-c-0.8.0 && \
	make && \
	make install  
WORKDIR /tmp/amqp-1.7.1
RUN	phpize
RUN 	./configure --with-amqp --with-librabbitmq-dir=/usr/local/rabbitmq-c-0.8.0 && \
	make && \
	make install
#开启amqp拓展/usr/lib/php5/20121212/amqp.so
RUN sed -i "s/;   extension=msql\.so/;   extension=msql\.so\n   extension=\/usr\/lib\/php5\/20121212\/amqp.so/g"  /etc/php5/apache2/php.ini
RUN sed -i "s/;   extension=msql\.so/;   extension=msql\.so\n   extension=\/usr\/lib\/php5\/20121212\/amqp.so/g"  /etc/php5/cli/php.ini


#编译安装xdebug todo 注意此处XDEBUG_HOST写固定了 后期更改成容器启动的环境变量
ADD soft/xdebug-2.5.5.tgz /tmp
WORKDIR /tmp/xdebug-2.5.5
RUN phpize
RUN ./configure --with-php-config=/usr/bin/php-config && make && make install

RUN echo "[xdebug]\n \
zend_extension=/usr/lib/php5/20121212/xdebug.so \n \
xdebug.remote_enable = 1 \n \
xdebug.profiler_enable =0 \n \
xdebug.profiler_enable_trigger = 1 \n \
xdebug.profiler_output_name = [%t]_%R.profile \n \
xdebug.profiler_output_dir = /data/__PHPDEBUG__ \n \
xdebug.auto_trace = 0 \n \
xdebug.trace_output_dir = /data/__PHPDEBUG__ \n \
xdebug.remote_port = 19001 \n \
xdebug.ideky= XDEBUG_SESSION \n \
xdebug.remote_host=10.20.103.87 \n \
xdebug.remote_autostart = 0  \n" \
>> /etc/php5/apache2/php.ini

RUN /usr/sbin/php5enmod mcrypt



# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

VOLUME  ["/etc/php5"]




EXPOSE 80
WORKDIR /data
CMD ["/run.sh"]
