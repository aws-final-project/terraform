terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "hhs-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "hhs-vpc"
  }
}

# Create the subnet
resource "aws_subnet" "hhs-public-subnet" {
  vpc_id     = aws_vpc.hhs-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "hhs-public-subnet"
  }
}

# Create the internet gateway
resource "aws_internet_gateway" "hhs-gw" {
  vpc_id = aws_vpc.hhs-vpc.id

  tags = {
    Name = "hhs-gw"
  }
}

# Create the route table
resource "aws_route_table" "hhs-public-route-table" {
  vpc_id = aws_vpc.hhs-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hhs-gw.id
  }

  tags = {
    Name = "hhs-public-route-table"
  }
}

# Create route table association with public subnet
resource "aws_route_table_association" "route-one" {
  subnet_id      = aws_subnet.hhs-public-subnet.id
  route_table_id = aws_route_table.hhs-public-route-table.id
}

# Create security group for public http access for the ec2 with java api
resource "aws_security_group" "hhs-api-sec-group" {
  name        = "hhs-api-sec-group"
  description = "allowing http and ssh"
  vpc_id      = aws_vpc.hhs-vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 8080
    to_port           = 8080
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hhs-api-sec-group"
  }
}

# create EC2 that will have our api
resource "aws_instance" "hhs-api-ec2" {
  ami           = "ami-04ad2567c9e3d7893" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.hhs-api-sec-group.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.hhs-public-subnet.id
  key_name = "hhs-key"
  user_data = file("install.sh")

  tags = {
    Name = "hhs-api-ec2"
  }
}