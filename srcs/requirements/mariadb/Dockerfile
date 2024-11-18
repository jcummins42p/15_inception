# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/01 16:13:31 by jcummins          #+#    #+#              #
#    Updated: 2024/11/15 19:00:56 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#	MARIADB
FROM debian:12

RUN apt-get update -y && \
	apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/* && apt-get clean

RUN	mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
	chmod -R 750 /var/lib/mysql /var/run/mysqld

COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./config/db-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/db-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["db-entrypoint.sh"]
