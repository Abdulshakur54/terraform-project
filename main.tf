terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}


#provider
provider "aws" {
  profile = "default"
  region = "us-east-1"
}



#vpc
resource "aws_vpc" "web" {
  cidr_block       = var.vpc-cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc-name
  }
}

#public subnet
resource "aws_subnet" "web-pub-subnet-us-east-1a" {
  vpc_id     = aws_vpc.web.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "web-pub-subnet-us-east-1a"
  }
}



#internet-gateway
resource "aws_internet_gateway" "web-internet-gateway" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = "web-internet-gateway"
  }
}


#route-table
resource "aws_route_table" "public-subnet-route-table" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-internet-gateway.id
  }


  tags = {
    Name = "public-subnet-route-table"
  }
}

#route-table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.web-pub-subnet-us-east-1a.id
  route_table_id = aws_route_table.public-subnet-route-table.id
}


#security-group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound and outbound traffic from port 22"
  vpc_id      = aws_vpc.web.id

  tags = {
    Name = "allow_ssh"
  }
}

# security-group inbound rule
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}



# security-group outbound rule
resource "aws_vpc_security_group_egress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


#EC2 in the public subnet
resource "aws_instance" "web-server" {
  ami           = "ami-012967cc5a8c9f891"
  instance_type = var.ec2-instance-type
  associate_public_ip_address = true
  subnet_id = aws_subnet.web-pub-subnet-us-east-1a.id
  key_name = "my-key-pair"
  user_data = var.ec2-user-data
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = var.ec2-instance-name
  }
}