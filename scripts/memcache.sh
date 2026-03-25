#!/bin/bash

# ==========================================
# Memcached Setup Script
# Installs and configures Memcached service
# ==========================================

# ==========================================
# INSTALLATION
# ==========================================

# Install EPEL repository (required for memcached on CentOS/RHEL)
dnf install epel-release -y

# Install Memcached
dnf install memcached -y


# ==========================================
# SERVICE MANAGEMENT
# ==========================================

# Start Memcached service
systemctl start memcached

# Enable Memcached to start on boot
systemctl enable memcached

# Check Memcached status
systemctl status memcached


# ==========================================
# CONFIGURATION
# ==========================================

# Allow Memcached to listen on all network interfaces
# (Required for communication from other VMs)
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Restart Memcached to apply changes
systemctl restart memcached


# ==========================================
# FIREWALL CONFIGURATION
# ==========================================

# Open Memcached TCP port
firewall-cmd --add-port=11211/tcp

# Make firewall rule persistent
firewall-cmd --runtime-to-permanent

# Open Memcached UDP port
firewall-cmd --add-port=11111/udp

# Make firewall rule persistent
firewall-cmd --runtime-to-permanent


# ==========================================
# OPTIONAL: MANUAL MEMCACHED START (CUSTOM PORTS)
# ==========================================

# Start Memcached with explicit ports (TCP:11211, UDP:11111)
# NOTE: This may conflict with systemctl-managed service in real-world setups
memcached -p 11211 -U 11111 -u memcached -d


# ==========================================
# END OF SCRIPT
# ==========================================

echo "Memcached setup completed successfully!"
