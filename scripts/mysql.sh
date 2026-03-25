#!/bin/bash

# ==========================================
# MySQL (MariaDB) Setup Script
# Installs, configures, and initializes database
# ==========================================

# Database root password
DATABASE_PASS='admin123'

# ==========================================
# SYSTEM PREPARATION
# ==========================================

# Update system packages
yum update -y

# Install required dependencies
yum install epel-release -y
yum install git zip unzip -y

# Install MariaDB (MySQL)
yum install mariadb-server -y


# ==========================================
# SERVICE MANAGEMENT
# ==========================================

# Start and enable MariaDB service
systemctl start mariadb
systemctl enable mariadb


# ==========================================
# APPLICATION SOURCE CODE
# ==========================================

# Clone application repository (contains DB backup)
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git


# ==========================================
# DATABASE CONFIGURATION & HARDENING
# ==========================================

# Set root password
mysqladmin -u root password "$DATABASE_PASS"

# Remove insecure default users and databases
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"

# Apply changes
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"


# ==========================================
# APPLICATION DATABASE SETUP
# ==========================================

# Create application database
mysql -u root -p"$DATABASE_PASS" -e "CREATE DATABASE accounts"

# Create application user and grant access
mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY 'admin123'"
mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123'"

# Import database backup
mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql

# Apply privileges again
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"


# ==========================================
# FIREWALL CONFIGURATION
# ==========================================

# Enable firewall service
systemctl start firewalld
systemctl enable firewalld

# Open MySQL port (3306) for remote access
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload


# ==========================================
# FINAL STEP
# ==========================================

# Restart MariaDB service
systemctl restart mariadb

echo "MySQL (MariaDB) setup completed successfully!"