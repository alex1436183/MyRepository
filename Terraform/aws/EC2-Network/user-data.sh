#!/bin/bash
apt update -y
apt install -y nginx net-tools
systemctl start nginx 
systemctl enable nginx