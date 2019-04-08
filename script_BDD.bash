#!/bin/bash
#destination : /home/Desktop/scripts/script_BDD.bash

#Vérifie si le package mariadb est installé, si non l'installe
if yum list installed "mariadb" >/dev/null 2>&1; then
	echo "mariadb_installed"
else
	yum -y install mariadb >/dev/null
fi

#Vérifie si le package mariadb-server est installé, si non l'installe
if yum list installed "mariadb-server" >/dev/null 2>&1; then
echo "mariad-server_installed"
else
	yum -y install mariadb-server  >/dev/null
fi

echo installation terminée

#Lancement du module mariadb et activation au démarrage
systemctl enable mariadb
systemctl start mariadb 

#Execution des commandes pour configurer la base de données
mysql -u root --password="" -e "UPDATE mysql.user SET Password=PASSWORD('BOURNE') WHERE User='root';"
mysql -u root --password="" -e "FLUSH PRIVILEGES;"
mysql -u root --password="BOURNE" -e "DROP DATABASE IF EXISTS wordpress;"
mysql -u root --password="BOURNE" -e "CREATE DATABASE wordpress;"
mysql -u root --password="BOURNE" -e "DROP USER admin;"
mysql -u root --password="BOURNE" -e "CREATE USER admin@'localhost' IDENTIFIED BY 'admin';"
mysql -u root --password="BOURNE" -e "GRANT ALL PRIVILEGES ON wordpress.* TO admin@'localhost' IDENTIFIED BY 'admin';"




