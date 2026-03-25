#!/bin/bash

# ==========================================
# Nginx Setup Script
# Configures Nginx as reverse proxy
# ==========================================

# ==========================================
# INSTALLATION
# ==========================================

# Update package list
apt update

# Install Nginx
apt install nginx -y


# ==========================================
# NGINX CONFIGURATION
# ==========================================

# Create reverse proxy configuration file
cat <<EOT > /etc/nginx/sites-available/vproapp

# Define upstream application server
upstream vproapp {
    server app01:8080;
}

# Configure server block
server {
    listen 80;

    location / {
        proxy_pass http://vproapp;
    }
}

EOT


# ==========================================
# ENABLE CONFIGURATION
# ==========================================

# Remove default config
rm -rf /etc/nginx/sites-enabled/default

# Enable new config
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp


# ==========================================
# SERVICE MANAGEMENT
# ==========================================

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Restart to apply configuration
systemctl restart nginx

echo "Nginx setup completed successfully!"