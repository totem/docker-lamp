FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get -y install supervisor
RUN apt-get -y install mysql-server
RUN apt-get -y install apache2 php5 php5-mysql php5-mcrypt php5-imagick php5-curl libapache2-mod-auth-mysql libapache2-mod-php5 curl

ADD provision/site.conf /etc/apache2/sites-available/site

# Setup supervisord
RUN mkdir -p /var/log/supervisor
ADD provision/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN a2dissite default
RUN a2ensite site

# Setup run command
EXPOSE 80

CMD ["/usr/bin/supervisord"]
