# Variable
DOMAIN=${ec2_domain}
ROOT_HTML=/usr/share/nginx/html
PHP=php8.2

# Update
sudo dnf update && sudo dnf upgrade -y

# Install tool
sudo dnf install -y git htop

# Install and config Nginx
sudo dnf install -y nginx

cat <<EOF | sudo tee /etc/nginx/conf.d/default.conf
server {
    listen 80;
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
sudo sh -c "echo '<?php echo gethostname(); phpinfo(); ?>' >> $ROOT_HTML/info.php"