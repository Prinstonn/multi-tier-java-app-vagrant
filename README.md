# 🚀 Automated Multi-Tier Java Web Application Deployment (Vagrant)

## 📌 Overview

This project demonstrates the deployment of a **distributed, multi-tier Java web application** using Infrastructure as Code (IaC) principles.

The system is fully automated using **Vagrant provisioning**, allowing the entire environment to be set up with a single command:

```bash
vagrant up
```

The architecture simulates a **production-like environment**, where each service runs on its own virtual machine.

---

## 🏗️ Architecture

The application is composed of multiple services working together:

* **Nginx** – Reverse proxy & load balancer
* **Apache Tomcat** – Hosts the Java web application
* **MySQL** – Database backend
* **Memcached** – Caching layer for performance optimization
* **RabbitMQ** – Message broker for asynchronous communication

Each service is deployed on a separate VM to ensure scalability and separation of concerns.

---

## ⚙️ Technologies Used

* Vagrant
* Shell Scripting
* Nginx
* Apache Tomcat
* MySQL
* Memcached
* RabbitMQ
* CentOS & Ubuntu
* Linux CLI

---

## 🔄 Automation

All infrastructure and configurations are automated using **Vagrant provisioning scripts**:

* Automated VM creation
* Automated package installation
* Automated service configuration
* Automated application deployment

This eliminates manual setup and ensures **consistency and reproducibility**.

---

## 🌐 How to Run the Project

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

### 2. Start the environment

```bash
vagrant up
```

### 3. Access the application

Open your browser and navigate to:

```
http://<NGINX_VM_IP>
```

---

## 📊 Key Learning Outcomes

* Designed and deployed a **multi-tier architecture**
* Implemented **Infrastructure as Code (IaC)** using Vagrant
* Configured **inter-service communication across VMs**
* Gained experience with **reverse proxying and load balancing**
* Improved understanding of **distributed systems and automation**

---

## 📎 Notes

This project was built as part of a guided tutorial and extended with additional automation and configuration improvements.

---

## 📸 Future Improvements

* Containerize the application using Docker
* Implement CI/CD pipeline (e.g., GitHub Actions)
* Deploy to a cloud platform (AWS, Azure, or GCP)

---

## 👤 Author

**Prinston Sarfo**
DevOps Engineer (In Progress 🚀)
