# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/28 11:31:22 by jcummins          #+#    #+#              #
#    Updated: 2024/11/06 18:40:16 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
SRCS = srcs

all: $(NAME)

$(NAME):
	@echo "Building docker project $(NAME)"
	sudo docker compose -f ./srcs/docker-compose.yaml up --build -d

nginx_shell:
	sudo docker exec -it nginx /bin/bash

wp_shell:
	sudo docker exec -it wordpress /bin/bash

clean:
	@echo "Stopping services"
	sudo docker stop $(shell sudo docker ps -q)
	@echo "Removing unused images"
	sudo docker system prune --force

fclean: clean

phony: clean fclean wp_shell nginx_shell
