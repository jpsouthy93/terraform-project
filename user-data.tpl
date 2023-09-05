#!/bin/bash

sudo apt update -y
sudo apt install -y nginx
sudo echo "Terraform Provisioned Me" > /var/www/html/index.html