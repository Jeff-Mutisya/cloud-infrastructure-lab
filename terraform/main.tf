# Illustrative Terraform skeleton — adapt AMI/region to your account.
# No credentials here: authenticate via environment or shared config.
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-web-sg"
  description = "Minimal lab SG: SSH from admin IP, HTTP/S public."
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from admin IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_ip}/32"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 8
    encrypted   = true
  }

  tags = { Name = "${var.name_prefix}-web", ManagedBy = "terraform", Lab = "cloud-infrastructure-lab" }
}
