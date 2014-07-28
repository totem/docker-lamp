FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get -y install supervisor mysql-server apache2 php5 php5-mysql php5-mcrypt php5-imagick php5-curl libapache2-mod-auth-mysql libapache2-mod-php5 curl

# Setup supervisord
RUN mkdir -p /var/log/supervisor
ADD provision/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup run command
EXPOSE 80

CMD ["/usr/bin/supervisord"]
