# Update
sudo dnf update -y && sudo dnf upgrade -y

# Install tool
sudo dnf install -y git htop

# Install MySQL Client
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm -P /tmp
sudo dnf install -y /tmp/mysql80-community-release-el9-1.noarch.rpm
sudo dnf update -y
sudo dnf install -y mysql-community-server