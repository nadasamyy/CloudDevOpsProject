Here’s the complete instructions formatted for a **README** file:

---

# **Instructions for AWS Integration in Terraform Code**

This document outlines the steps to integrate AWS resources in Terraform and apply the necessary configurations for EC2, VPC, Security Group, IAM Roles, Policies, and CloudWatch.

## **1. Prerequisites**
- Ensure you have an active **AWS account**.
- Install and configure **Terraform** on your local machine.
- Set up your **AWS credentials** using **AWS CLI** or **environment variables**:
  - **Access Key ID** and **Secret Access Key**.
  - Set the region, e.g., `us-east-1`, in your AWS provider configuration.

  Example AWS CLI configuration:
  ```bash
  aws configure
  ```

## **2. Set Up Your Terraform Configuration**
Here’s an overview of what needs to be done to configure AWS resources in your Terraform code.

### **a. Provider Configuration**
First, configure the AWS provider in your `main.tf` to authenticate and interact with AWS:

```hcl
provider "aws" {
  region = "us-east-1" # specify the desired region
}
```

### **b. VPC Setup**
Define your VPC (Virtual Private Cloud) configuration to provide networking isolation for your resources:

```hcl
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}
```

### **c. Subnet Creation**
Define subnets for your VPC where EC2 instances will reside. Two public subnets are created in this example:

```hcl
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet1"
  }
}
```

### **d. Internet Gateway**
Create an Internet Gateway to enable internet connectivity for your VPC:

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}
```

### **e. Security Group for EC2**
Define the Security Group to control access to EC2 instances (allowing SSH and HTTP access):

```hcl
resource "aws_security_group" "ec2_sg" {
  name = "ec2-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-Security-Group"
  }
}
```

### **f. IAM Role and Policy for CloudWatch**
Create an IAM Role and attach the necessary policies to allow EC2 instances to interact with CloudWatch:

```hcl
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "ec2-cloudwatch-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}
```

Create an IAM Policy with the necessary CloudWatch permissions:

```hcl
resource "aws_iam_policy" "ec2_cloudwatch_policy" {
  name = "ec2-cloudwatch-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}
```

### **g. EC2 Instance Module**
Define a module to deploy an EC2 instance and associate it with the IAM role and CloudWatch policy:

```hcl
module "ec2_instance1" {
  source             = "./modules/ec2"
  ami_id             = data.aws_ami.amazon_linux_23.id
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public_subnet_1.id
  key_name           = "Ec2Key"
  instance_name      = "app-server"
  security_groups_id = aws_security_group.ec2_sg.id
  ec2_cloudwatch_role_name = aws_iam_role.ec2_cloudwatch_role.name
}
```

## **3. CloudWatch Dashboard**
You can create a CloudWatch Dashboard to monitor EC2 metrics such as CPU utilization:

```hcl
resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  dashboard_name = "EC2MonitoringDashboard"

  dashboard_body = <<EOF
  {
    "widgets": [
      {
        "type": "metric",
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "${module.ec2_instance1.instance_id}" ]
          ],
          "period": 300,
          "stat": "Average",
          "region": "us-east-1",
          "title": "EC2 CPU Utilization"
        }
      }
    ]
  }
  EOF
}
```

## **4. Apply Terraform Code**
To apply the Terraform code:

### **a. Initialize the Terraform working directory:**
```bash
terraform init
```

### **b. Plan the execution to ensure the changes are correct:**
```bash
terraform plan
```

### **c. Apply the configuration to create resources:**
```bash
terraform apply
```

## **5. Verification**
After applying the Terraform configuration, you can verify the following:
- The **EC2 instance** is created in the specified subnet.
- **Security Group** allows SSH (port 22) and HTTP (port 80).
- **IAM role and policy** are attached to the EC2 instance for CloudWatch.
- **CloudWatch logs** and **metrics** are being sent correctly from the EC2 instance.

## **6. Cleanup**
To destroy the created resources and avoid unnecessary charges:

```bash
terraform destroy
```
