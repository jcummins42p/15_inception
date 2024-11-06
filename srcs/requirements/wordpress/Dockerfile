# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/06 16:03:10 by jcummins          #+#    #+#              #
#    Updated: 2024/11/06 19:19:34 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:12

RUN apt update && apt upgrade
RUN apt install -y php-fpm

COPY www.conf /etc/php/8.2/fpm/pool.d/.

CMD ["php-fpm8.2"]
