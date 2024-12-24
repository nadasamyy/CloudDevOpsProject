# CloudDevOpsProject

This repository contains the setup and containerization of a project named **CloudDevOpsProject**. The repository includes a **Dockerfile** for building the application image.

## **1. GitHub Repository Setup**

### **Task:**
- Create a new GitHub repository named **CloudDevOpsProject**.
- Initialize the repository with a **README** file.

### **Steps:**

1. **Create a GitHub Repository:**
   - Go to [GitHub](https://github.com/).
   - Log in with your GitHub account.
   - In the top-right corner, click on the `+` icon, then select **New repository**.
   - Name the repository **CloudDevOpsProject**.
   - Check the box to **Initialize this repository with a README**.
   - Click on **Create repository**.

2. **Verify the Repository:**
   - After creation, navigate to the repository URL: `https://github.com/<your-username>/CloudDevOpsProject`.
   - Ensure that the **README** file is visible in the repository.

### **Deliverables:**
- The **URL** to the GitHub repository:  
  Example: `https://github.com/<your-username>/CloudDevOpsProject`

---

## **2. Containerization with Docker**

### **Task:**
- Deliver a **Dockerfile** for building the application image.
- Find the source code from the repository: [Ibrahim-Adell/FinalProjectCode](https://github.com/Ibrahim-Adell/FinalProjectCode).

### **Steps:**

1. **Clone the Source Code:**
   - Clone the repository to your local machine:
     ```bash
     git clone https://github.com/Ibrahim-Adell/FinalProjectCode.git
     ```
   - Change to the directory where the code is located:
     ```bash
     cd FinalProjectCode
     ```

2. **Create the Dockerfile:**
   - In the root of the project, create a file named `Dockerfile` with the following content:

     ```dockerfile
     # Use an official Java runtime as a parent image
     FROM adoptopenjdk:11-jre-hotspot

     # Set the working directory in the container
     WORKDIR /app

     # Copy the JAR file from the build/libs directory into the container
     COPY build/libs/demo-0.0.1-SNAPSHOT.jar app.jar

     # Expose the application port
     EXPOSE 8081

     # Run the JAR file when the container starts
     CMD ["java", "-jar", "app.jar"]
     ```

   - This **Dockerfile** uses the **adoptopenjdk:11-jre-hotspot** base image to run the Java application, exposes port `8081`, and runs the JAR file `demo-0.0.1-SNAPSHOT.jar`.

3. **Build the Docker Image:**
   - Build the Docker image using the following command:
     ```bash
     docker build -t clouddevopsproject .
     ```
   - The `-t` flag tags the image with the name `clouddevopsproject`.

4. **Run the Docker Container:**
   - After building the image, run the container on port `8081`:
     ```bash
     docker run -p 8081:8081 clouddevopsproject
     ```

5. **Test the Container:**
   - Once the container is running, open a web browser and visit `http://localhost:8081` to ensure the application is working as expected.

6. **Add the Dockerfile to GitHub:**
   - Add the `Dockerfile` to Git:
     ```bash
     git add Dockerfile
     ```
   - Commit the changes with a descriptive message:
     ```bash
     git commit -m "Add Dockerfile for Java application"
     ```
   - Push the changes to the remote repository:
     ```bash
     git push origin main
     ```
 # task3: EC2 Module & Infrastructure Setup with Terraform**

This project demonstrates how to use Terraform to provision an AWS EC2 instance, VPC, subnets, security groups, and run a Dockerized application.

---

## **1. Overview**

This project automates the creation of AWS infrastructure, including:
- **VPC** with public subnets
- **EC2 instance** with Docker installed
- **Security groups** to control access
- **User data script** to install and run Docker containers

---

## **2. Infrastructure Components**

### **VPC & Subnets**
- Creates a **VPC** with two public subnets in different availability zones.

### **Security Group**
- Defines an **EC2 security group** to allow SSH (port 22) and HTTP (port 80) access.

### **EC2 Instance**
- Uses a **Terraform module** to create an EC2 instance with a Dockerized application running in a container.

---

## **3. Key Files**

### **main.tf**
- Defines the VPC, subnets, security group, and integrates the EC2 module.

### **ec2/main.tf**
- Provisions the EC2 instance, including user data for installing Docker and running the app.

### **variables.tf**
- Contains variables for customizing the EC2 instance, AMI ID, instance type, etc.

---

## **4. How to Use**

### **Step 1: Initialize Terraform**
```bash
terraform init
terraform plan
terraform apply         
