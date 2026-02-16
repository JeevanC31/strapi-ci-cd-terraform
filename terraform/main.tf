provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "strapi-terraform-state-jeevan"
    key     = "task-6/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}



data "aws_vpc" "default" {
  default = true
}


data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH and Strapi"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Strapi"
    from_port   = 1337
    to_port     = 1337
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
    Name = "strapi-security-group"
  }
}


resource "aws_instance" "strapi_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  user_data_replace_on_change = true

user_data = <<-EOF
#!/bin/bash

apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo '/swapfile none swap sw 0 0' >> /etc/fstab
sysctl vm.swappiness=10
echo 'vm.swappiness=10' >> /etc/sysctl.conf

docker pull ${var.image_tag}

docker run -d -p 1337:1337 \
-e HOST=0.0.0.0 \
-e PORT=1337 \
-e APP_KEYS="appKey1,appKey2,appKey3,appKey4" \
-e API_TOKEN_SALT="salt" \
-e ADMIN_JWT_SECRET="adminSecret" \
-e JWT_SECRET="jwtSecret" \
--restart unless-stopped \
--name strapi \
jeevanc31/strapi-app:${var.image_tag}

EOF


  tags = {
    Name = "StrapiServer"
  }
}


resource "aws_eip" "strapi_eip" {
  instance = aws_instance.strapi_server.id
  domain   = "vpc"
}


