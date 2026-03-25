#!/bin/bash

# ==========================================
# Tomcat Setup (Ubuntu - Package Based)
# ==========================================

# Update system
apt update
apt upgrade -y

# Install Java (required for Tomcat)
apt install openjdk-8-jdk -y

# Install Tomcat and related packages
apt install tomcat8 tomcat8-admin tomcat8-docs tomcat8-common git -y

echo "Tomcat (Ubuntu package version) installed successfully!"