#!/bin/bash
# http://www.krazyworks.com/restart-apache-mysql-when-low-on-memory/
threshold=85 #percent
total=$(free | grep "Mem:" | awk '{print $2}')
remaining=$(free | grep "Mem:" | awk '{print $4}')
current=$(echo "scale=0;100-$remaining * 100 / $total" | bc -l)
 
if [ $current -gt $threshold ]
then
      /etc/init.d/apache2 stop
      /etc/init.d/apache2 start
 
      echo "Restarted apache  on `date +'%Y-%m-%d %H:%M:%S'`. RAM utilization at {current}%" >> /var/log/apache_mysql_restarter.log
fi
