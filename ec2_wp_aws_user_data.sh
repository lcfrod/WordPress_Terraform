#!/bin/bash

# Prepare for AWS CodeDeploy
# Install AWS CodeDeploy Agent in EC2 Instance -- Update 25/05/25
# Reference : https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-ubuntu.html
sudo apt update
sudo apt install ruby-full    -y
sudo apt install wget         -y
sudo apt install apache2      -y
sudo systemctl start apache2
sudo systemctl enable apache2

cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto   

# For a specific version :
# aws s3 ls s3://aws-codedeploy-us-east-1/releases/ --region us-east-1 | grep '\.deb$'
# sudo ./install auto -v releases/codedeploy-agent_1.7.1-110_all.deb > /tmp/ec2_user_data_logfile

# Make sure the codedeploy is started
sudo systemctl start codedeploy-agent

#=================================================================================
# Install WordPress on Ubuntu
# Ref : https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview


# Install Dependencies for WordPress
sudo apt update
sudo apt install apache2 \
                 ghostscript \
                 libapache2-mod-php \ 
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip  -y


# Install WordPress
sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

# Configure Apache for WordPress
# Set up your Apache web server so they can serve WordPress files online. 
# sudo nano /etc/apache2/sites-available/wordpress.conf

echo "<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/wordpress.conf

# Enable the WordPress site setup so Apache can serve you by running these commands:
sudo a2ensite wordpress
sudo a2enmod rewrite

# Disable the default Apache site for your web server to display the correct WordPress page:
sudo a2dissite 000-default

# Update Apache to ensure that all changes are applied correctly:
sudo service apache2 reload