#!/bin/bash
yum install httpd -y
chkconfig httpd on
echo "<h2> Ugam Api Demo </h2>" > /var/www/html/index.html
service httpd start