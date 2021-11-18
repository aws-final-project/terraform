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

# Create private subnet for RDS
resource "aws_subnet" "hhs-private-subnet" {
  vpc_id = aws_vpc.hhs-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    "Name" = "hss-private-subnet"
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

# TODO: Create Security Group for RDS to allow internal traffic in
resource "aws_security_group" "hhs-rds-sec-group" {
  name        = "hhs-rds-sec-group"
  vpc_id      = aws_vpc.hhs-vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 5432
    to_port           = 5432
    protocol          = "tcp"
    cidr_blocks       = ["10.0.1.0/24"]
  }

  # Not sure this will work without a NAT?
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hhs-rds-sec-group"
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

resource "aws_db_subnet_group" "hhs-subnet-group" {
  subnet_ids = [aws_subnet.hhs-public-subnet.id, aws_subnet.hhs-private-subnet.id]

  tags = {
    Name = "hhs-subnet-group"
  }
}

# TODO: Create RDS Resource
resource "aws_db_instance" "hhs-rds-postgres" {
  allocated_storage    = 10
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  name                 = "hhsPostgress"
  username             = "postgres"
  password             = "password"
  parameter_group_name = "default.postgres13"
  db_subnet_group_name = aws_db_subnet_group.hhs-subnet-group.name
  vpc_security_group_ids = [aws_security_group.hhs-api-sec-group.id, aws_security_group.hhs-rds-sec-group.id]

    tags = {
      Name = "aws-project-db"
    }
}

# Create Output Variable
# output "ec2-public-IPV4" {
#   value = aws_instance.web.public_ip
# }