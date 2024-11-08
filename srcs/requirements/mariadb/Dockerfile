# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/01 16:13:31 by jcummins          #+#    #+#              #
#    Updated: 2024/11/08 18:36:26 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:12

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y mariadb-server
RUN rm -rf /var/lib/apt/lists*	# cleans package list to reduce image size

EXPOSE 3306

LABEL version="1.0"
LABEL description="mariadb"

#HEALTHCHECK --start-period=5m \
	#CMD mariadb -e 'SELECT @@datadir;' || exit 1

CMD ["mysqld", "-F"]

