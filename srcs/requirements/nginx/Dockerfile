# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/01 16:13:31 by jcummins          #+#    #+#              #
#    Updated: 2024/11/06 16:44:05 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#	defines which base os to use
FROM debian:12

# install nginx and ssl
RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y openssl
RUN apt-get install -y net-tools
RUN apt-get install -y vim

RUN mkdir /etc/nginx/ssl
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

COPY ./conf/nginx.conf /etc/nginx/conf.d/ssl.conf
COPY html/index.html /usr/share/nginx/html/index.html
COPY default /etc/nginx/sites-available/.

RUN mkdir -p /run/nginx

#	443 is the https port
EXPOSE 443

LABEL version="1.0"
LABEL description="nginx"

#CMD ["nginx"]
CMD ["nginx", "-g", "daemon off;"]

