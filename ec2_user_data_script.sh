#!/bin/bash
echo "Making this script verbose"
set -x
echo "Starting execution of user data"

# ---------------------------------------------------------------------------
echo "# Installing  AWS CodeDeploy"
# ---------------------------------------------------------------------------
# Install AWS CodeDeploy Agent in EC2 Instance -- Update 25/05/25
# Reference : https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-ubuntu.html
sudo apt update
sudo apt install curl -y
sudo apt install ruby-full -y
sudo apt install wget -y
sudo apt install apache2 -y
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
## ============================================================
# # Install  WordPress
# Referencia : https://medium.com/@TechmanDevops/terraform-deploy-wordpress-em-uma-inst%C3%A2ncia-aws-e95cd910be61
#              https://ubuntu.com/tutorials/install-and-configure-wordpress#3-install-wordpress

# ---------------------------------------------------------------------------
echo "# 1. Connect to your server and create an account" - Optional
# ---------------------------------------------------------------------------

# adduser username
# usermod -a -G sudo username
# su username

# ---------------------------------------------------------------------------
echo "# 2. Install WordPress dependencies"
# ---------------------------------------------------------------------------
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl restart apache2
sudo systemctl status apache2
sudo DEBIAN_FRONTEND=noninteractive apt install mysql-server -y
sudo DEBIAN_FRONTEND=noninteractive apt install php -y
sudo apt install php-fpm -y
sudo apt install php-php-gettext -y
sudo apt install php-{curl,pear,cgi,curl,mbstring,gd,xml,bcmath,json,xml,fpm,intl,zip,imap} -y
sudo systemctl restart php8.1-fpm # When working with  php -v = 8.1.2

echo "# Ubuntu version for  ImageMagick"
sudo DEBIAN_FRONTEND=noninteractive apt install -y imagemagick libmagickwand-dev
sudo DEBIAN_FRONTEND=noninteractive apt install -y php-imagick
sudo systemctl restart apache2

echo "# 3. Download and install WordPress"
sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

# ---------------------------------------------------------------------------
echo "# 4. Configure the Apache for Wordpress"
# ---------------------------------------------------------------------------
echo '<VirtualHost *:80>
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
</VirtualHost> ' | sudo tee -a /etc/apache2/sites-available/wordpress.conf

sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload                                                              

# ---------------------------------------------------------------------------
echo "# 5. Configure database/user for Wordpress"
# ---------------------------------------------------------------------------
 
 echo "export MYSQL_HOST="${rds_address}"" >> /etc/environment


#mysql --host="${rds_address}" --user=admin --password="${rds_password}" wordpressdb -e "CREATE DATABASE wordpressdb;"
mysql --host="${rds_address}" --user=admin --password="${rds_password}" wordpressdb -e "CREATE USER 'wordpuser' IDENTIFIED BY 'wordp#123'";
mysql --host="${rds_address}" --user=admin --password="${rds_password}" wordpressdb -e "GRANT ALL PRIVILEGES ON wordpressdb.* TO wordpuser";
mysql --host="${rds_address}" --user=admin --password="${rds_password}" wordpressdb -e "FLUSH PRIVILEGES";

sudo systemctl start mysql
sudo systemctl status mysql

echo "**** End of the User data script  ****"

# ---------------------------------------------------------------------------
#6. Configure WordPress to connect to the database
# ---------------------------------------------------------------------------

sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/database_name_here/wordpressdb/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/wordpuser/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/wordp#123/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/localhost/${rds_address}/' /srv/www/wordpress/wp-config.php


# Download the new Keys for 
curl https://api.wordpress.org/secret-key/1.1/salt/  >   new_keys.lst

# Implement the keys on the file  wp-config.php
for (( wlinein=0; wlinein<9; wlinein++ )); do
  LINE_TO_INSERT=$(sed -n "$wlinein p"  new_keys.lst)    # Get the new keys
  linesdown=51
  wlineout=$((wlinein + linesdown))
  sudo sed -i " $wlineout c\ $LINE_TO_INSERT"  /srv/www/wordpress/wp-config.php   # And insert then in wp-config
done

# Delete the  staging file with the keys
rm  new_keys.lst

 
echo "============    End of User Script   ============================
