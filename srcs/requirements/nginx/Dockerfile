# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/01 16:13:31 by jcummins          #+#    #+#              #
#    Updated: 2024/11/01 17:14:08 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#	defines which base os to use
FROM debian:12

RUN apt-get update
RUN apt-get install -y nginx
RUN ufw app list
RUN ufw allow 'Nginx HTTP'
RUN ufw status

EXPOSE 3306

LABEL version="1.0"
LABEL description="NGINX container"

CMD ["mariadbd"]

