#!/bin/bash    

# Install AWS CodeDeploy Agent in EC2 Instance -- Update 25/05/25
# Reference : https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-ubuntu.html
sudo apt update
sudo apt install ruby-full    -y
sudo apt install wget         -y
sudo apt install apache2      -y
sudo systemctl start apache2
sudo systemctl enable apache2

cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto   

# For a specific version :
# aws s3 ls s3://aws-codedeploy-us-east-1/releases/ --region us-east-1 | grep '\.deb$'
# sudo ./install auto -v releases/codedeploy-agent_1.7.1-110_all.deb > /tmp/ec2_user_data_logfile

# Make sure the codedeploy is started
sudo systemctl start codedeploy-agent
