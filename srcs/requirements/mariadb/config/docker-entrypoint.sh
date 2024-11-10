#!/bin/bash

# This causes script to exit immediately if any command fails, to prevent issues
set -e

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Initialize the database if not already initialized
# conditional expressions in square brackets [ -n ] and spaces are neccesary
# each keyword like if then else must start on a new line or follow a ;
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysqld --initialize-insecure

    echo "Starting MariaDB temporarily..."
    mysqld --skip-networking &
    pid="$!"

    mysql=( mysql --protocol=socket -uroot )

    # Wait for MariaDB to be ready
    for i in {30..0}; do
        if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
            break
        fi
        echo 'MariaDB is initializing...'
        sleep 1
    done

    # Set root password and enforce password authentication
    echo "Configuring root password and user permissions..."
    echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '${DB_ROOT}';" | "${mysql[@]}"
    echo 'FLUSH PRIVILEGES;' | "${mysql[@]}"

    # Set up initial database, user, and permissions
    echo "Setting up initial database and user..."
    echo "CREATE DATABASE IF NOT EXISTS ${DB_NAME};" | "${mysql[@]}"
    echo "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';" | "${mysql[@]}"

    # Shutdown temporary MariaDB instance
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo 'MariaDB initialization process failed.'
        exit 1
    fi
fi

echo "Granting database privileges to user..."
echo "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';" | "${mysql[@]}"
echo 'FLUSH PRIVILEGES;' | "${mysql[@]}"

# Start MariaDB in the foreground
exec mysqld --user=mysql
