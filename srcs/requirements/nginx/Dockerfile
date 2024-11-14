# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/01 16:13:31 by jcummins          #+#    #+#              #
#    Updated: 2024/11/14 13:03:20 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#	NGINX
FROM debian:12

# install nginx and ssl
RUN apt-get update && \
	apt-get install -y nginx openssl net-tools && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean && \
	mkdir /etc/nginx/ssl

# self-generates the SSL certificate, initializing the variables
# openssl req - starts the command
# -newkey rsa:4096 generates a new RSA key of size 4096 bits
# -x509 	specifies the output should be self-signed cert, not CSR
# -sha256	specifies the hashing algorithm
# -days 	specifies the period of validity
# -nodes	indicates that the private key should not be passphrase encrypted
# -out		specifies the output location for the certificate
# -keyout	specifies the output location for the private key
# -subj		provides the subject info directly, without interactive prompts
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
		-out /etc/nginx/ssl/jcummins.crt \
		-keyout /etc/nginx/ssl/jcummins.key \
		-subj "/C=CZ/ST=Prague/L=Prague/O=42_School/OU=jcummins42/CN=jcummins/"

#	global settings for nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
#	site specific configuration file with ssl - contains server block
COPY ./conf/ssl.conf /etc/nginx/conf.d/ssl.conf

RUN mkdir -p /run/nginx

#	443 is the https port
EXPOSE 443

LABEL version="1.0"
LABEL description="nginx"

#CMD ["nginx"]
CMD ["nginx", "-g", "daemon off;"]
#CMD ["nginx", "-F"] - this didn't work :(

