#!/bin/bash

# This causes script to exit immediately if any command fails
set -e

echo "Searching for directory at /var/lib/mysql/mysql..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "System tables not found at /var/lib/mysql/mysql"

	echo "Initializing database..."
	mariadb-install-db --user=mysql \
		--datadir=/var/lib/mysql \
		--basedir=/usr
else
	echo "> System table found, skipping mariadb-install-db"
fi

echo "Searching for directory at /var/lib/mysql/${MYSQL_DATABASE}..."
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo "> Starting MariaDB temporarily to set up database and user..."
	mysqld --skip-networking &
	pid="$!"

	echo "> Waiting for MariaDB to start"
	for i in {30..0}; do
		if mysqladmin ping &> /dev/null; then
			echo "> MariaDB is running";
			break
		fi
		echo "> waiting..."
		sleep 1
	done

	if [ "$i" = 0 ]; then
		echo "> Error: MariaDB failed to start"
		exit 1
	fi

	# Set root password and enforce password authentication
	mysql -uroot <<-EOF
		SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
	EOF

	# Shutdown temporary MariaDB instance
	if ! kill -s TERM "$pid" || ! wait "$pid"; then
		echo '> MariaDB initialization process failed.'
		exit 1
	fi
else
	echo "> ${MYSQL_DATABASE} found, skipping initialization"
fi

echo "Starting MariaDB in the foreground..."
exec mysqld --user=mysql
