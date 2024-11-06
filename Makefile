# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/28 11:31:22 by jcummins          #+#    #+#              #
#    Updated: 2024/11/06 19:05:05 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
SRCS = srcs

all: $(NAME)

$(NAME):
	@echo "Building docker project $(NAME)"
	sudo docker compose -f ./srcs/docker-compose.yaml up --build -d

status:
	@echo "DOCKER CONTAINERS:"
	@sudo docker ps -a
	@echo "DOCKER IMAGES:"
	@sudo docker images

nginx_shell:
	sudo docker exec -it nginx /bin/bash

wp_shell:
	sudo docker exec -it wordpress /bin/bash

clean:
	@echo "Stopping services"
	sudo docker stop $(shell sudo docker ps -aq)
	@echo "Removing unused images"
	sudo docker system prune --force

fclean: clean
	sudo docker system prune --all --force --volumes

phony: clean fclean wp_shell nginx_shell
