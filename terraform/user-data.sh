#!/bin/bash
apt update
apt install -y nginx
echo "<h1>Web Server - $(hostname)</h1>" > /var/www/html/index.html
systemctl enable nginx
systemctl start nginx
