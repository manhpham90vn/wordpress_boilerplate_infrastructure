# Variable
ROOT_PASSWORD=${mysql_root_password}
DB_USER=${mysql_db_user}
DB_PASSWORD=${mysql_db_password}
DB_NAME=${mysql_db_name}
REMOTE_IP=${ssh_ip}
DOMAIN=${ec2_domain}
ROOT_HTML=/usr/share/nginx/html
PHP=php8.2
REMOTE_IP_WITHOUT_MASK=echo $REMOTE_IP | cut -c -3

# Update
sudo dnf update && sudo dnf upgrade -y

# Install tool
sudo dnf install -y git

# Install and config Nginx
sudo dnf install -y nginx

cat <<EOF | sudo tee /etc/nginx/conf.d/fullchain.pem
${fullchain}
EOF

cat <<EOF | sudo tee /etc/nginx/conf.d/privkey.pem
${privkey}
EOF

cat <<EOF | sudo tee /etc/nginx/conf.d/default.conf
server {
  listen 80;
  server_name $DOMAIN www.$DOMAIN;
  return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/conf.d/fullchain.pem;
    ssl_certificate_key /etc/nginx/conf.d/privkey.pem;
    server_name $DOMAIN www.$DOMAIN;
    index index.php index.html index.htm;
    root $ROOT_HTML;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

    location / {
        try_files \$uri \$uri/ /index.php?q=\$uri\$args;
    }

    location ~ \.php$ {
        try_files \$uri \$uri/ /index.php?q=\$uri\$args;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php-fpm/www.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOF
sudo systemctl enable nginx
sudo systemctl start nginx

# Install and config MariaDB
sudo dnf install mariadb105-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Create database and mysql user
cat > mysql_secure_installation.sql << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF
sudo mysql < mysql_secure_installation.sql 
cat > installation.sql << EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
CREATE USER '$DB_USER'@'$REMOTE_IP_WITHOUT_MASK' IDENTIFIED BY '$DB_PASSWORD';
CREATE USER '$DB_USER'@'$DOMAIN' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'admin'@'localhost';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'admin'@'$REMOTE_IP_WITHOUT_MASK';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'admin'@'$DOMAIN';
FLUSH PRIVILEGES;
EOF
sudo mysql -uroot -p$ROOT_PASSWORD  < installation.sql

# Update MariaDB config allow remote login
sudo sed -i 's/#bind-address=0.0.0.0/bind-address=0.0.0.0/' /etc/my.cnf.d/mariadb-server.cnf
sudo systemctl restart mariadb

# Install Redis
sudo dnf install -y redis6
sudo systemctl enable redis6
sudo systemctl start redis6

# Install php and extension
sudo dnf install -y php $PHP-fpm $PHP-cli $PHP-mysqlnd $PHP-bcmath $PHP-devel $PHP-pdo $PHP-common $PHP-gd $PHP-mbstring $PHP-xml $PHP-intl php-pear
sudo systemctl enable php-fpm
sudo systemctl start php-fpm
printf "\n" | sudo pecl install redis
sudo sh -c "echo 'extension=redis.so' >> /etc/php.ini"
sudo systemctl restart php-fpm
sudo systemctl reload nginx

# Test
sudo sh -c "echo '<?php phpinfo();' >> $ROOT_HTML/info.php"