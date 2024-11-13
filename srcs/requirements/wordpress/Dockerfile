# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/06 16:03:10 by jcummins          #+#    #+#              #
#    Updated: 2024/11/13 18:08:06 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#	WORDPRESS
FROM debian:12

#	apt-get is more stable and less likely to break automated processes
#	it is more commonly used in sever environments and scripts because it is older
#	php = php interpreter - core functionality for php scripts
#	php-fpm = php Fastcgi Process Manager
#	php-mysqli = allows php to interact with MySQL databases
#	php-json = Provides json support in php
#	php-curl = cURL allows php to make https requests to other servers.
#	php-dom = DocumentObjectModel to manipulate XML and HTML documents in php
#	php-exif = ExchangeableImageFileFormat to read metadata from image files
#	php-fileinfo = to determine file type based on content rather than its extension,
#					useful for file validation
#	php-mbstring = MultiByteString to handle extended/multibyte character encodings
#	php-openssl = allows php to perform encryption and decryption operations
#	php-xml = tools to parse and manipulate XML data
#	php-zip = tools to read and write ZIP archive files
#	php-redis = to connect to a redis server, powerful in-memory key-value data store.
#				used for caching and session storage in web applications, increasing
#				performance by reducing need to access database for common calls.

#	wget = downloading files - used to get the latest WordPress ZIP archive
#	unzip =	extract ZIP archive files like the WordPress archive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	php8.2 \
	php-fpm \
	php-mysqli \
	php-json \
	php-curl \
	php-dom \
	php-exif \
	php-fileinfo \
	php-mbstring \
	php-xml \
	php-redis \
	wget \
	unzip \
	default-mysql-client \
	iputils-ping \
	vim
RUN	rm -rf /var/lib/apt/lists/* && apt-get clean

RUN mkdir -p /var/www/ # make sure the directory exists

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/.
COPY ./conf/wp-entrypoint.sh /usr/local/bin/
COPY ./conf/wp-config.php /var/www/
RUN chmod +x /usr/local/bin/wp-entrypoint.sh

WORKDIR /var/www/

#	the -F flag tells the command to run in the foreground as process ID 1
#	without this, the container will close since they are designed to run PID 1
#	essentially the opposite of -d (Daemon/background) or -d detached mode for docker
#	Having both entrypoint and cmd runs the entrypoint script with the cmd argument.
ENTRYPOINT ["wp-entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
