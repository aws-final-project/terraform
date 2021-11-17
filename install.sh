#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install git -y
git clone https://github.com/aws-final-project/aws-final-project.git