#!/bin/bash
#destination : /home/Desktop/scripts/script_lancement.bash

#Vérifie si php est installé, si non l'installe
if yum list installed "php" >/dev/null 2>&1; then
	echo "php installed"
else
	yum -y install php 
fi

#Vérifie si php-mysql est installé, si non l'installe
if yum list installed "php-mysql" >/dev/null 2>&1; then
	echo "php-mysql-installed"
else
	yum -y install php-mysql 
fi

#désactive le pare-feu
systemctl disable firewalld
systemctl stop firewalld
#Vérifie si httpd est installé, si non l'installe
if yum list installed "httpd" >/dev/null 2>&1; then
	echo "php-mysql-installed"
else
	yum -y install httpd
fi

#relance le service httpd pour mettre à jour
service httpd restart
#récupère et extrait l'archive contenant wordpress
cd ~
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
#copie le contenu de l'archive dans le dossier de base des sites web locaux
rsync -avP ~/wordpress/ /var/www/html/
#créé un dossier nécessaire au bon fontionnement du site et change le propriétaire du répertoire pour pouvoir le lancer
mkdir /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/*
#créé un fichier wp-config.php depuis un template pour configurer le site
cd /var/www/html
cp wp-config-sample.php wp-config.php
#configure des informations du site à propos de la base de données
sed -i -- 's/database_name_here/wordpress/g' wp-config.php
sed -i -- 's/username_here/admin/g' wp-config.php
sed -i -- 's/password_here/admin/g' wp-config.php
#change les droits et le proprétaire des nouveaux fichiers et repertoires créés
chown apache:apache /var/www/html/wp-config.php
chmod 755 -R /var/www/html
#ouvre la page de configuration du site
firefox "http://localhost/wp-admin/install.php"
