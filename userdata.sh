#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
TOKEN=$(curl -X PUT "http://169.254.169" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169)
echo "<h1>3-Tier Production App Live!</h1><p>Served from Availability Zone: <b>$AZ</b></p>" > /var/www/html/index.html
