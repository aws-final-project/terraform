#!/usr/bin/env bash
set -euo pipefail
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jq -y
PROJPATH=/home/ec2-user/aws-final-project
git clone https://github.com/aws-final-project/aws-final-project.git $PROJPATH
cd $PROJPATH
sudo chmod +x gradlew
sudo ./gradlew build
#final step run command with secret password