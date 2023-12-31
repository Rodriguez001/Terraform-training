#! /bin/bash


# INSTALLE AUTOMATIQUEMENT  WORDPRESS ET MARIADB SUR DES AMI LINUX 2 


# Modifiez ces valeurs et conservez-les en lieu sûr
db_root_password=rodrigue-root.P@ssword
db_username=utilisateur_wordpress
db_user_password=rodrigue-Utilisateur.P@ssword
db_name=wordpress_db

# installer le serveur LAMP
sudo yum update -y
# installer le serveur apache
sudo yum install -y httpd
 

# activez d'abord php7.xx depuis amazon-linux-extra et installez-le

amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}
# installer l'extension Imagick
sudo yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
cat <<EOF >>/etc/php.d/20-imagick.ini
extension=imagick
EOF
systemctl restart php-fpm.service
#  téléchargez le package mysql et mariadb grâce à yum  
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --os-type=rhel  --os-version=7 --mariadb-server-version=10.7
sudo rm -rf /var/cache/yum
sudo yum makecache
sudo yum install -y MariaDB-server MariaDB-client


systemctl start  httpd
systemctl start mysqld

# Changer le PROPRIÉTAIRE et les autorisations du répertoire /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Télécharger le package wordpress et l'extraire
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

# mysql_secure_installation AUTOMATIQUE 
# modifier l'autorisation du fichier journal des erreurs pour extraire le mot de passe root initial
chown  ec2-user:apache /var/log/mysqld.log
temppassword=$(grep 'temporary password' /var/log/mysqld.log | grep -o ".\{12\}$")
chown  mysql:mysql /var/log/mysqld.log

# changer le mot de passe root 
mysql -p$temppassword --connect-expired-password  -e "SET PASSWORD FOR root@localhost = PASSWORD('$db_root_password');FLUSH PRIVILEGES;" 
mysql -p'$db_root_password'  -e "DELETE FROM mysql.user WHERE User='';"
mysql -p'$db_root_password' -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"


# Créer un utilisateur de base de données et accorder des privilèges
mysql -u root -p"$db_root_password" -e "GRANT ALL PRIVILEGES ON *.* TO '$db_username'@'localhost' IDENTIFIED BY '$db_user_password';FLUSH PRIVILEGES;"

# Créer une base de données
mysql -u $db_username -p"$db_user_password" -e "CREATE DATABASE $db_name;"

# Créer un fichier de configuration wordpress et mettre à jour la valeur de la base de données
cd /var/www/html
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_user_password/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF

# Modifier l'autorisation de /var/www/html/
chown -R ec2-user:apache /var/www/html
chmod -R 774 /var/www/html

#  activer les fichiers .htaccess dans la configuration Apache à l'aide de la commande sed
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

#Make apache and mysql to autostart and restart apache
systemctl enable  httpd.service
sudo systemctl enable --now mariadb
systemctl restart httpd.service