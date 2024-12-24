
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

 security_groups        = [var.security_groups_id]  # Security group for instance

  # User data script to install Docker, build and run the Docker container
  user_data = <<-EOF
              #!/bin/bash
              # Update and install Docker
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker

              # Create the app directory and copy the necessary files
              mkdir -p /app
              cp /tmp/demo-0.0.1-SNAPSHOT.jar /app/app.jar
              cp /tmp/Dockerfile /app/Dockerfile

              # Build and run the Docker container
              docker build -t demo-app /app
              docker run -d -p 8081:8081 demo-app
              EOF

  tags = {
    Name = var.instance_name
  }

  # Provisioner to upload files (Dockerfile and JAR) to EC2 instance
  provisioner "file" {
    source      = "./Dockerfile"  # Path to Dockerfile on your local machine
    destination = "/tmp/Dockerfile"  # Upload to /tmp directory on EC2
  }

  provisioner "file" {
    source      = "./build/libs/demo-0.0.1-SNAPSHOT.jar"  # Path to JAR file
    destination = "/tmp/demo-0.0.1-SNAPSHOT.jar"  # Upload to /tmp on EC2
  }
 


}
