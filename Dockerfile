# This will need to change
FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get -y install supervisor
RUN apt-get -y install mysql-server
RUN apt-get -y install apache2 php5 php5-mysql php5-mcrypt php5-imagick php5-curl libapache2-mod-auth-mysql libapache2-mod-php5 curl
RUN apt-get -y install unzip


# Add the provisioning and install the Berkshelf cookbooks
# /ADD chef /opt/provision
# WORKDIR /opt/provision
# RUN /bin/bash -l -c "berks install --path /opt/provision/cookbooks"

RUN curl -o /tmp/craft.zip http://download.buildwithcraft.com/craft/2.0/2.0.2535/Craft-2.0.2535.zip

# Add craft content
RUN mkdir /var/craft
RUN unzip /tmp/craft.zip -d /var/craft
RUN rm /tmp/craft.zip
RUN chown -R www-data:www-data /var/craft/
RUN chmod -R 744 /var/craft/craft/app
RUN chmod -R 744 /var/craft/craft/config
RUN chmod -R 744 /var/craft/craft/storage

# Configure craft
RUN sed -i "s/'database' => ''/'database' => 'craft'/" /var/craft/craft/config/db.php

# Run Chef solo
# RUN chef-solo -j /opt/provision/dna.json -c /opt/provision/solo.rb

ADD provision/craft.conf /etc/apache2/sites-available/craft

ADD provision/mysql.cnf /etc/mysql/my.cnf

# Setup supervisord
RUN mkdir -p /var/log/supervisor
ADD provision/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN a2dissite default
RUN a2ensite craft

ADD provision/create-craft-db.sh /create-craft-db.sh

RUN /create-craft-db.sh

# Setup run command
EXPOSE 80

CMD ["/usr/bin/supervisord"]
