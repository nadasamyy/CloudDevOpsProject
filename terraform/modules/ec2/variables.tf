variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the instance will be created"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair to use"
  type        = string
}

variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
}

variable "security_groups_id" {
  description = "The security group ID to associate with the instance"
  type        = string
}
variable "ec2_cloudwatch_role_name" {
  description = "The IAM role for EC2 instances to send logs to CloudWatch"
  type        = string
}
