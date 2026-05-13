# Tell Terraform to use the AWS plugin
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Which AWS region to create resources in
# us-east-1 = North Virginia (free tier friendly)
provider "aws" {
  region = "us-east-1"
}
# RESOURCE 1: Security Group (firewall)
# AWS blocks all traffic by default — this opens port 5000 and 22
resource "aws_security_group" "todo_sg" {
  name = "todo-app-sg"

  ingress {  # Allow incoming on port 5000 (your app)
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {  # Allow incoming on port 22 (SSH to manage server)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {  # Allow all outgoing (to pull Docker images etc.)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# RESOURCE 2: EC2 Instance (your virtual server)
resource "aws_instance" "todo_server" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 in us-east-1
  instance_type = "t3.micro"         
  key_name      = "Key pair"       # Free tier — 1 CPU, 1GB RAM

  vpc_security_group_ids = [aws_security_group.todo_sg.id]

  # Script that runs ONCE on first boot
  # Installs Docker and runs your app automatically
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    docker pull YOUR_DOCKERHUB_USERNAME/todo-app:latest
    docker run -d -p 5000:5000 Prachi0930/todo-app:latest
     EOF

  tags = { Name = "todo-app-server" }
}

# Print the server IP after terraform apply finishes
output "server_ip" {
  value = aws_instance.todo_server.public_ip
}
