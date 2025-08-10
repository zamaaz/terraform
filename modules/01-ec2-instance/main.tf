provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my-instance" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  user_data = var.user_data

  iam_instance_profile = var.iam_instance_profile_name

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh-access-sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow HTTP traffic from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    description = "Allow HTTP on 8080 from anywhere for testing"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access-sg"
  }
}