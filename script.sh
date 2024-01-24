#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo apt install mysql-server -y
sudo apt install php libapache2-mod-php php-mysql -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y phpmyadmin
PMA_ROOT_PASS="Test@12345"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$PMA_ROOT_PASS';"
echo 'Include /etc/phpmyadmin/apache.conf' | sudo tee -a /etc/apache2/apache2.conf
sudo systemctl restart apache2
sudo ufw enable
sudo ufw allow "Apache Full"


sudo rm -r /var/www/html/{*,.*}
git clone https://github.com/banago/simple-php-website.git /var/www/html

# Configure Apache
cat <<EOL > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Enable Apache rewrite module
sudo a2enmod rewrite

# Restart Apache
sudo service apache2 restart

# Set correct permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
