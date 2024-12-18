#!/bin/bash

# This causes script to exit immediately if any command fails
set -e

echo "Checking for wp install at /var/www/wordpress"
if [ ! -d "/var/www/wordpress" ]; then
	echo "> Wordpress install not found"

	echo "> Downloading wordpress to /var/www/..."
	wget https://wordpress.org/latest.zip
	unzip latest.zip
	cp -r wordpress/* .
	rm -rf wordpress/* latest.zip
	sh wp-config-gen.sh
else
	echo "> Wordpress install found, skipping download"
fi

touch /var/log/php8.2-fpm.log
chown www-data:www-data /var/log/php8.2-fpm.log
chown -R www-data:www-data /var/www/
echo "Starting php-fpm in the foreground..."
exec "$@"	# $@ = all of the command-line arguments to the shell script
