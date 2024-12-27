# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet2"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Route Table with Public Subnet 1
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate Route Table with Public Subnet 2
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Data block to fetch the latest Amazon Linux
data "aws_ami" "amazon_linux_23" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# Create a Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-Security-Group"
  }
}

# IAM Role for EC2 to send logs to CloudWatch
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

# IAM Policy for CloudWatch logs and metrics
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

# Attach the policy to the IAM Role
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_attachment" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.ec2_cloudwatch_policy.arn
}

# CloudWatch Dashboard
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

# EC2 Module
module "ec2_instance1" {
  source             = "./modules/ec2"
  ami_id             = data.aws_ami.amazon_linux_23.id
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public_subnet_1.id
  key_name           = "Ec2Key"
  instance_name      = "app-server"
  security_groups_id = aws_security_group.ec2_sg.id
  ec2_cloudwatch_role_name  = aws_iam_role.ec2_cloudwatch_role.name  # Pass IAM role name
}
