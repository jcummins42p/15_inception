# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/01 16:13:31 by jcummins          #+#    #+#              #
#    Updated: 2024/11/10 12:45:29 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#	MARIADB
FROM debian:12

RUN apt-get update -y && \
	apt-get upgrade -y  && \
	apt-get install -y mariadb-server vim gosu && \
	rm -rf /var/lib/apt/lists/* && apt-get clean

RUN	mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./config/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#USER mysql

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]

#	note for posterity - getting this database to behave was the most annoying thing imaginable. I couldn't even log in as root to see what the permissions problem was. Absolutely infuriating. Currently trying to install gosu so that I can run it as sudo on the entrypoint script. How can this be intended behaviour?
