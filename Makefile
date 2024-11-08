# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/28 11:31:22 by jcummins          #+#    #+#              #
#    Updated: 2024/11/08 18:28:11 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
SRCS = srcs

all: $(NAME)

$(NAME):
	@echo "Building docker project $(NAME)"
	docker compose -f ./srcs/docker-compose.yaml up --build -d

status:
	@echo ">> DOCKER CONTAINERS:"
	@docker ps -a
	@echo ">> DOCKER IMAGES:"
	@docker images
	@echo ">> DOCKER VOLUMES:"
	@docker volume ls

shell_ng:
	docker exec -it nginx /bin/bash

shell_wp:
	docker exec -it wordpress /bin/bash

shell_db:
	docker exec -it mariadb /bin/bash

fclean: stop iclean vclean

stop:
	@echo "Stopping services"
	docker stop $(shell sudo docker ps -aq)

clean:
	@echo "Removing unused images"
	docker system prune --force

vclean:
	@echo "Removing docker volumes"
	docker volume rm $(docker volume ls -q)

iclean:
	@echo "Removing docker images"
	docker rmi -f $(docker images -q)

phony: clean fclean wp_shell nginx_shell
