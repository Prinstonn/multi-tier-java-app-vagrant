#!/bin/bash

# ==========================================
# Backend Services Setup Script
# Installs and configures:
# - Memcached (Caching)
# - RabbitMQ (Message Broker)
# - MariaDB/MySQL (Database)
# ==========================================

# Database root password
DATABASE_PASS='admin123'

# ==========================================
# MEMCACHED SETUP
# ==========================================

# Install EPEL repository (required for memcached)
yum install epel-release -y

# Install Memcached
yum install memcached -y

# Start and enable Memcached service
systemctl start memcached
systemctl enable memcached

# Verify Memcached status
systemctl status memcached

# Run Memcached on custom ports (TCP:11211, UDP:11111)
memcached -p 11211 -U 11111 -u memcached -d


# ==========================================
# RABBITMQ SETUP
# ==========================================

# Install dependencies
yum install socat -y
yum install erlang -y
yum install wget -y

# Download RabbitMQ package
wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-3.6.10-1.el7.noarch.rpm

# Import RabbitMQ signing key
rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc

# Update system packages
yum update -y

# Install RabbitMQ
rpm -Uvh rabbitmq-server-3.6.10-1.el7.noarch.rpm

# Start and enable RabbitMQ service
systemctl start rabbitmq-server
systemctl enable rabbitmq-server

# Verify RabbitMQ status
systemctl status rabbitmq-server

# Allow remote connections (disable loopback restriction)
echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

# Create RabbitMQ user and assign admin role
rabbitmqctl add_user rabbit bunny
rabbitmqctl set_user_tags rabbit administrator

# Restart RabbitMQ to apply configuration
systemctl restart rabbitmq-server


# ==========================================
# MYSQL (MariaDB) SETUP
# ==========================================

# Install MariaDB server
yum install mariadb-server -y

# Allow remote connections by binding to all interfaces
sed -i 's/^127.0.0.1/0.0.0.0/' /etc/my.cnf

# Start and enable MariaDB service
systemctl start mariadb
systemctl enable mariadb

# ==========================================
# DATABASE CONFIGURATION & HARDENING
# ==========================================

# Set root password
mysqladmin -u root password "$DATABASE_PASS"

# Secure MySQL installation manually
mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root'"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Create application database
mysql -u root -p"$DATABASE_PASS" -e "CREATE DATABASE accounts"

# Create application user and grant privileges
mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY 'admin123'"
mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'app01' IDENTIFIED BY 'admin123'"

# Restore database from backup file
mysql -u root -p"$DATABASE_PASS" accounts < /vagrant/vprofile-repo/src/main/resources/db_backup.sql

# Apply privilege changes
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart MariaDB service
systemctl restart mariadb


# ==========================================
# END OF SCRIPT
# ==========================================

echo "Backend services setup completed successfully!"