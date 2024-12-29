# **Cloud DevOps Infrastructure Project**

✨ **Project Overview**
This project showcases a comprehensive DevOps pipeline, leveraging cutting-edge tools and techniques to achieve seamless integration and deployment. By combining **Terraform**, **Ansible**, and **Jenkins**, the infrastructure is automated from provisioning to deployment, ensuring scalability, reliability, and efficiency. The project is deployed on **AWS**, utilizing cloud-native features like monitoring with CloudWatch, IAM roles for security, and dynamic scaling.

Key Features:
- End-to-end CI/CD automation, reducing manual intervention.
- Infrastructure as Code (IaC) with Terraform for reproducible environments.
- Configuration Management using Ansible for consistent and repeatable setups.
- Continuous monitoring and feedback using SonarQube and AWS CloudWatch.

---

🗷 **Architecture Components**
- 🛠️ Effortless Jenkins CI/CD Server Setup with JCasC.
- 🔍 SonarQube Code Quality Server for continuous improvement.
- 📊 AWS CloudWatch for real-time monitoring and alerts.
- 🗂️ Terraform-managed Infrastructure for scalable and reproducible environments.
- 🔧 Configuration Management with Ansible for automation and consistency.

---

🚀 **Getting Started**

✅ **Prerequisites**
- 🌐 AWS Account and configured AWS CLI.
- 📦 Terraform installed (v1.0.0+).
- 🔧 Ansible installed (v2.9+).
- 🔑 SSH key pair for EC2 instances.

---

💫 **Infrastructure Deployment**

### **1. Terraform Configuration**

#### **Our infrastructure as code setup includes:** 
- 🖥️ VPC with public subnet and security groups.
- 🚀 EC2 instances with dynamic resource allocation.
- 🗂️ S3 backend configuration for state management.
- 📊 CloudWatch monitoring dashboard to monitor CPU utilization on EC2 instances.
- 🔒 IAM roles for secure access and monitoring.

#### **Setup Steps**

1. Initialize and apply:
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

---

### **2. Ansible Configuration**

#### **Ansible automates the installation and configuration of:**

**Primary EC2 Instance**
- 🤖 Jenkins Server with preconfigured plugins.
- ☕ Java 11 & 17.
- 🧰 Git for version control.
- 🐳 Docker for containerization.
- 🔍 SonarQube for code quality analysis.
- 📂 OpenShift CLI for Kubernetes management.

#### **Deployment Steps**

1. Update `ansible.cfg`:
    Ensure the Ansible configuration file (`ansible.cfg`) is updated with:
    ```ini
    [defaults]
    inventory = ./inventory
    remote_user = ec2-user
    private_key_file = ./Ec2Key.pem
    roles_path = ./roles
    [privilege_escalation]
    become = True
    become_method = sudo
    become_user = root
    ```
2. Update `playbook.yml`:  
    Ensure the playbook that runs our roles (`playbook.yml`) is updated with:
    ```yaml
    ---
    - name: Install Jenkins
      hosts: web
      become: yes
      roles:
        - java-21
        - git
        - jenkins

    - name: Install Development Tools
      hosts: web
      become: yes
      roles:
        - java-11
        - git
        - docker
        - sonarqube
        - oc
    ```
   
3. Run the playbook:
    ```bash
    ansible-playbook -i inventory playbook.yml
    ```

---

### **3. Jenkins Configuration**

#### **1. Plugins Installation**
Install required Jenkins plugins:
```bash
  sonarqube-scanner \
  git \
  docker-workflow \
  github
```

#### **2. Tools Installation**
Install required Jenkins tools:
```bash
jdk11
jdk17
```

#### **3. Jenkins Configuration as Code (JCasC)**
Create the slave agent, pipeline, and all required configurations using `jenkins.yml`.

**Steps:**
- Create the directory if it doesn't exist:
    ```bash
    sudo mkdir -p /var/lib/jenkins/config
    ```

- Move the configuration file:
    ```bash
    sudo mv jenkins.yml /var/lib/jenkins/config/
    ```

- Set proper ownership and permissions:
    ```bash
    sudo chown -R jenkins:jenkins /var/lib/jenkins/config
    sudo chmod 644 /var/lib/jenkins/config/jenkins.yml
    ```

- Verify the file:
    ```bash
    ls -la /var/lib/jenkins/config/
    ```

- Restart Jenkins:
    ```bash
    sudo systemctl restart jenkins
    ```

#### **4. Configure Required Credentials 🔑:**
- Slave SSH private key.
- Git access token.
- Docker access token.
- SonarQube access token.

Now, **Run the Pipeline** ✨✨✨

---

📍 **Important Notes**

### 🌐 Access Information
- Jenkins: `http://jenkins-server-IP:8080`
- SonarQube: `http://slave-tools-IP:9000`
- Default SonarQube credentials:
    - Username: `admin`
    - Password: `admin`

### 🔍 Monitoring
CloudWatch dashboards and alarms are automatically configured to monitor:
- Instance health.
- Resource utilization (CPU, memory, disk).
- Application metrics (e.g., request counts, error rates).

---

### **Authors**
Nada Samy
