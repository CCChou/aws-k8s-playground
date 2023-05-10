terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-04e914639d0cca79a"
  instance_type          = "t2.micro"
  key_name               = "app_server"
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  tags = {
    Name = "ExampleAppServerInstance"
  }

  depends_on = [
    aws_default_vpc.default
  ]
}

resource "aws_key_pair" "app_server_keypair" {
  key_name   = "app_server"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+gHqR+UcG5iwP9Yb5izqxdoX50hJoRSgVuCqWjskxioPkwgGJgM4wiIHVTlD7t2U6GfUzS7/dy77u7Xz57z8x5VpOl3qZwCGbSu6l7bizldc+WYA1G8MGVZ0AY8J/ComE/eUPro6XffDQfY0BfRnf66gfZ/2KbjylSXd6lNln5mNIVNXpI3BV0tyfHRng+nDqJEBisGKG8HNHCeONWni3Us6iA630TmgaZmVOHqdsr7EXlJu9lEWqee4Hod+SaGVqSMsIQD9yoDamH5ZLZRMpE9NxsI3CiNHeCTShRYiEqWSnqB0/1IQcYWlxom+YRVg7qc4v17/lr3zLoX6V7GCF12Vfzux3DJIkXL+91YbSOchn2R67FCekNaejzlblC7d42wi9r0XlT465JHBLkUZTwe/sy0CpK9M0oDvWc49eX6A+hKjkiaooTJWgylF/vg+/x/6xZLPRtJ/eZwvBW7roXaBm5J58wTTDAJKFdwtbK9812swHE1FUWzZHBZWm2Z0= dennischou@dechou-mac"
}

resource "aws_security_group" "app_server_sg" {
  name = "app_server_sg"

  ingress = [{
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app_server_sg"
  }
}
