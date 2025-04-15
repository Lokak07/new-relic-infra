#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>Welcome to Nginx on Ubuntu!</h1>" > /var/www/html/index.html