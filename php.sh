#atualizar o php

add-apt-repository ppa:ondrej/php -y
add-apt-repository ppa:ondrej/apache2 -y
apt update

#pacotes e modulos utilizados
apt install php8.3 php8.3-bz2 php8.3-cli php8.3-common php8.3-curl php8.3-gd php8.3-mbstring \
php8.3-mysql php8.3-opcache php8.3-pgsql \
php8.3-readline php8.3-sqlite3 php8.3-xml php8.3-zip \
libapache2-mod-php8.3 php8.3-readline -y

#definir como versão principal
sudo update-alternatives --set php /usr/bin/php8.3
sudo a2dismod php8.1
sudo a2enmod php8.3
systemctl restart apache2

apt remove php8.1-common -y

apt install neovim -y
