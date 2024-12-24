To complete the task for **Configuration Management with Ansible** and set up the **Ansible environment** to configure your EC2 instances with the required packages, follow these detailed steps:

### 1. **Set Up the Ansible Environment**

Since you've already installed Ubuntu and Ansible on your system, let's proceed with setting up the required Ansible environment.

#### Step 1: Install Necessary Dependencies
You’ll need some packages for your Ansible setup (e.g., Python, SSH), which are required to manage remote systems like EC2.

Run the following commands in the Ubuntu terminal (inside VS Code terminal):

```bash
sudo apt update
sudo apt install -y python3-pip python3-dev sshpass
```

Now install **boto3** and **ansible** using pip to interact with AWS:

```bash
pip3 install boto3 ansible
```

Ensure that your EC2 instances are accessible via SSH and you have the appropriate keys to manage them.

### 2. **Set Up EC2 Instance Configuration Using Ansible Playbooks**

Create a directory for your Ansible playbooks in your project:

```bash
mkdir ~/ansible_playbooks
cd ~/ansible_playbooks
```

In this directory, we will create the necessary files to configure your EC2 instances.

#### Step 1: **Create Ansible Directory Structure**

A common structure for Ansible playbooks using roles would look like this:

```bash
ansible_playbooks/
├── inventory/
│   └── hosts
├── playbooks/
│   └── main.yml
└── roles/
    ├── git/
    │   └── tasks/
    │       └── main.yml
    ├── docker/
    │   └── tasks/
    │       └── main.yml
    ├── java/
    │   └── tasks/
    │       └── main.yml
    ├── jenkins/
    │   └── tasks/
    │       └── main.yml
    ├── sonarqube/
    │   └── tasks/
    │       └── main.yml
```

#### Step 2: **Create the `inventory/hosts` File**

The `hosts` file contains the details of the EC2 instances you want to manage. You’ll need to provide the IP addresses or DNS of the instances and the SSH credentials.

Example of the `hosts` file:

```ini
[ec2_instances]
ec2_instance_1 ansible_host=ec2-xx-xx-xx-xx.compute-1.amazonaws.com ansible_ssh_user=ubuntu ansible_ssh_private_key_file=path_to_your_ssh_private_key
```

#### Step 3: **Create Ansible Roles for Each Task**

Now, let’s create individual roles for installing the required packages (Git, Docker, Java, Jenkins, SonarQube).

##### 1. **Create Role for Git (`roles/git/tasks/main.yml`)**:

```yaml
---
# Install Git
- name: Install Git
  apt:
    name: git
    state: present
    update_cache: yes
```

##### 2. **Create Role for Docker (`roles/docker/tasks/main.yml`)**:

```yaml
---
# Install Docker
- name: Install Docker
  apt:
    name: docker.io
    state: present
    update_cache: yes

- name: Ensure Docker service is running
  service:
    name: docker
    state: started
    enabled: yes
```

##### 3. **Create Role for Java (`roles/java/tasks/main.yml`)**:

```yaml
---
# Install Java (OpenJDK 11)
- name: Install OpenJDK 11
  apt:
    name: openjdk-11-jdk
    state: present
    update_cache: yes
```

##### 4. **Create Role for Jenkins (`roles/jenkins/tasks/main.yml`)**:

```yaml
---
# Install Jenkins
- name: Add Jenkins repo key
  apt_key:
    url: https://pkg.jenkins.io/jenkins.io.key
    state: present

- name: Add Jenkins repository
  apt_repository:
    repo: "deb http://pkg.jenkins.io/debian/ stable main"
    state: present

- name: Install Jenkins
  apt:
    name: jenkins
    state: present
    update_cache: yes

- name: Ensure Jenkins is running
  service:
    name: jenkins
    state: started
    enabled: yes
```

##### 5. **Create Role for SonarQube (`roles/sonarqube/tasks/main.yml`)**:

```yaml
---
# Install SonarQube
- name: Install Java for SonarQube
  apt:
    name: openjdk-11-jdk
    state: present
    update_cache: yes

- name: Download SonarQube
  get_url:
    url: https://binaries.sonarsource.com/CommercialEdition/sonarqube-9.7.1.62043.zip
    dest: /opt/sonarqube.zip

- name: Unzip SonarQube
  unarchive:
    src: /opt/sonarqube.zip
    dest: /opt
    creates: /opt/sonarqube

- name: Ensure SonarQube is started
  command:
    cmd: /opt/sonarqube/bin/linux-x86-64/sonar.sh start
```

### 3. **Create Main Playbook (`playbooks/main.yml`)**

In the main playbook, we will import the roles we created earlier and apply them to the EC2 instances.

```yaml
---
- name: Configure EC2 Instances
  hosts: ec2_instances
  become: yes
  roles:
    - git
    - docker
    - java
    - jenkins
    - sonarqube
```

### 4. **Run the Ansible Playbook**

Once you have set up the playbooks and roles, it’s time to run the playbook and configure the EC2 instances.

Run the following command from the root of your `ansible_playbooks` directory:

```bash
ansible-playbook -i inventory/hosts playbooks/main.yml
```

This will apply the configuration and install the required packages on the EC2 instances.

---

### 4. **Commit the Playbooks to the Repository**

Once the playbook has been successfully run, commit the changes to your Git repository.

```bash
git add ansible_playbooks/
git commit -m "Add Ansible playbooks for EC2 instance configuration"
git push
```

---

### 5. **Verify the Installation**

After running the playbook, verify the following:
- **Git**: Run `git --version` on the EC2 instance.
- **Docker**: Run `docker --version`.
- **Java**: Run `java -version`.
- **Jenkins**: Open `http://<ec2-ip>:8080` in a browser to see Jenkins.
- **SonarQube**: Open `http://<ec2-ip>:9000` in a browser to see SonarQube.

---

### Conclusion

You’ve now completed the **Ansible configuration** for your EC2 instances, which will install the necessary packages (Git, Docker, Java, Jenkins, SonarQube) and set up environment variables as required. You can commit the playbooks to your repository, and the EC2 instances will be configured using the roles defined in your Ansible playbooks.

Let me know if you need further assistance!
