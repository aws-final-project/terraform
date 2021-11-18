#! /bin/bash
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jq -y
git clone https://github.com/aws-final-project/aws-final-project.git /home/ec2-user/aws-final-project
cd aws-final-project
sudo chmod +x gradlew
sudo ./gradlew build
#final step run command with secret password