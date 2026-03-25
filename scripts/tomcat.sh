#!/bin/bash

# ==========================================
# Apache Tomcat Setup Script (Manual Install)
# Builds and deploys Java application
# ==========================================

# Tomcat download URL
TOMURL="https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz"


# ==========================================
# INSTALL DEPENDENCIES
# ==========================================

# Install Java and required tools
dnf install -y java-17-openjdk java-17-openjdk-devel
dnf install -y git wget unzip zip rsync


# ==========================================
# DOWNLOAD & INSTALL TOMCAT
# ==========================================

cd /tmp/

# Download Tomcat
wget $TOMURL -O tomcatbin.tar.gz

# Extract archive
EXTOUT=$(tar xzvf tomcatbin.tar.gz)
TOMDIR=$(echo $EXTOUT | cut -d '/' -f1)

# Create dedicated Tomcat user (security best practice)
useradd --shell /sbin/nologin tomcat

# Copy files to installation directory
rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat/

# Set ownership
chown -R tomcat:tomcat /usr/local/tomcat


# ==========================================
# CREATE SYSTEMD SERVICE
# ==========================================

cat <<EOT > /etc/systemd/system/tomcat.service

[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat

ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

EOT

# Reload systemd and start Tomcat
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat


# ==========================================
# INSTALL MAVEN (BUILD TOOL)
# ==========================================

cd /tmp/

wget https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip
unzip apache-maven-3.9.9-bin.zip
cp -r apache-maven-3.9.9 /usr/local/maven3.9

# Set memory options
export MAVEN_OPTS="-Xmx512m"


# ==========================================
# BUILD APPLICATION
# ==========================================

# Clone project repository
git clone -b local https://github.com/hkhcoder/vprofile-project.git

cd vprofile-project

# Build application
/usr/local/maven3.9/bin/mvn install


# ==========================================
# DEPLOY APPLICATION
# ==========================================

# Stop Tomcat before deployment
systemctl stop tomcat
sleep 20

# Remove default app
rm -rf /usr/local/tomcat/webapps/ROOT*

# Deploy new application
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Start Tomcat
systemctl start tomcat
sleep 20


# ==========================================
# FIREWALL (DISABLED FOR SIMPLICITY)
# ==========================================

systemctl stop firewalld
systemctl disable firewalld


# ==========================================
# FINAL STEP
# ==========================================

systemctl restart tomcat

echo "Tomcat setup and application deployment completed!"