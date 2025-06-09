#!/bin/bash    

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
## ============================================================
# # Install  WordPress
# Referencia : https://medium.com/@TechmanDevops/terraform-deploy-wordpress-em-uma-inst%C3%A2ncia-aws-e95cd910be61
echo "# 1. Connect to your server and create an account"

# adduser username
# usermod -a -G sudo username
# su username

echo "# 2. Install WordPress dependencies"
sudo apt  update -y
sudo apt  install apache2 -y
sudo systemctl restart apache2
sudo systemctl status apache2
sudo DEBIAN_FRONTEND=noninteractive apt  install mysql-server  -y
sudo DEBIAN_FRONTEND=noninteractive apt  install php  -y;
sudo apt install    php-fpm -y
sudo apt  install   php-php-gettext -y
sudo apt  install  php-{curl,pear,cgi,curl,mbstring,gd,xml,bcmath,json,xml,fpm,intl,zip,imap}  -y
sudo systemctl restart php8.1-fpm       # When working with  php -v = 8.1.2

echo "# Ubuntu version for  ImageMagick"
sudo DEBIAN_FRONTEND=noninteractive apt install -y imagemagick   libmagickwand-dev
sudo DEBIAN_FRONTEND=noninteractive apt install -y php-imagick
sudo systemctl restart apache2

echo "# 3. Download and install WordPress"
sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

echo "# 4. Configure the Apache web server"
cat <<EOF>>  /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>  \
    DocumentRoot /srv/www/wordpress \
    <Directory /srv/www/wordpress> \
        Options FollowSymLinks \
        AllowOverride Limit Options FileInfo \
        DirectoryIndex index.php \
        Require all granted \
    </Directory> \
    <Directory /srv/www/wordpress/wp-content> \
        Options FollowSymLinks \
        Require all granted \
    </Directory> \
</VirtualHost>
EOF

sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload

mysql --host="${aws_db_instance.default.endpoint}" --user=admin --password=admin#123  wordpressdb  -e "SHOW DATABASES";
