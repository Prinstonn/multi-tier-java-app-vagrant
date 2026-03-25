#!/bin/bash

# ==========================================
# RabbitMQ Setup Script
# Installs and configures message broker
# ==========================================

# ==========================================
# INSTALLATION
# ==========================================

# Install required dependencies
yum install epel-release -y
yum update -y
yum install wget -y

# Add RabbitMQ repository
dnf -y install centos-release-rabbitmq-38

# Install RabbitMQ server
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server


# ==========================================
# SERVICE MANAGEMENT
# ==========================================

# Enable and start RabbitMQ
systemctl enable --now rabbitmq-server

# Verify service status
systemctl status rabbitmq-server


# ==========================================
# FIREWALL CONFIGURATION
# ==========================================

# Open RabbitMQ port (5672)
firewall-cmd --add-port=5672/tcp
firewall-cmd --runtime-to-permanent


# ==========================================
# CONFIGURATION
# ==========================================

# Allow remote connections (disable loopback restriction)
echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

# Create user and assign admin privileges
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator

# Grant full permissions
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"


# ==========================================
# FINAL STEP
# ==========================================

# Restart service to apply configuration
systemctl restart rabbitmq-server

echo "RabbitMQ setup completed successfully!"