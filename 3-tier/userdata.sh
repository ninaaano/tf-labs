#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Install AWS CLI
sudo yum install -y aws-cli

# Start Session Manager plugin
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

# Check if the Session Manager plugin is running
sudo systemctl status amazon-ssm-agent