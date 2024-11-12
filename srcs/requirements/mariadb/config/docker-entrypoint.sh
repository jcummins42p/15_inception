#!/bin/bash

# This causes script to exit immediately if any command fails, to prevent issues
set -e

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

echo "Testing whether ${MYSQL_DATABASE} already exists"
if [ ! -d "/var/lib/mysql/inception_db" ]; then

	echo "Initializing database..."
    mariadb-install-db --user=mysql \
		--datadir=/var/lib/mysql/

    echo "Starting MariaDB temporarily..."
    mysqld --skip-networking &
    pid="$!"

    # Wait for MariaDB to be ready
    for i in {30..0}; do
        if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
            break
        fi
        echo 'MariaDB is initializing...'
        sleep 1
    done

	if [ "$i" = 0 ]; then
		echo "Error:MAriaDB failed to start"
		exit 1
	fi

    # Set root password and enforce password authentication
	# heredoc EOSQL is sensitive to leading tabs unless I use this <<-
	mysql -uroot <<-EOSQL
		SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
	EOSQL

	# Shutdown temporary MariaDB instance
	if ! kill -s TERM "$pid" || ! wait "$pid"; then
		echo 'MariaDB initialization process failed.'
		exit 1
	fi
else
	echo "Database ${MYSQL_DATABASE} already exists. Skipping initialization"
fi

# Start MariaDB in the foreground
exec mysqld --user=mysql
