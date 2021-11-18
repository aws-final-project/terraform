#! /bin/bash
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install java-openjdk11 -y
git clone https://github.com/aws-final-project/aws-final-project.git /home/ec2-user/aws-final-project