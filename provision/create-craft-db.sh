#!/bin/bash
/usr/bin/mysqld_safe > /dev/null 2>&1 &\

RET=1
while [[ RET -ne 0 ]]; do
	sleep 1
	mysql -uroot -e "CREATE DATABASE craft;"
	RET=$?
done

mysqladmin -uroot shutdown

echo "Craft database created!"

# sleep 10s
# mysql -uroot -e "CREATE DATABASE craft;"
# exec supervisord -n
