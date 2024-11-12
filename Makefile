# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/28 11:31:22 by jcummins          #+#    #+#              #
#    Updated: 2024/11/12 19:16:28 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
SRCS = srcs

all: $(NAME)

$(NAME):
	@echo "Building docker project $(NAME)"
	docker compose -f ./srcs/docker-compose.yaml up --build -d

re:
	@echo "Building docker project without cache"
	docker compose -f ./srcs/docker-compose.yaml build --no-cache
	docker compose -f ./srcs/docker-compose.yaml up -d

status:
	@echo ">> DOCKER CONTAINERS:"
	@docker ps -a
	@echo "\n>> DOCKER IMAGES:"
	@docker images
	@echo "\n>> DOCKER VOLUMES:"
	@docker volume ls

shell_ng:
	docker exec -it nginx /bin/bash

shell_wp:
	docker exec -it wordpress /bin/bash

shell_db:
	docker exec -it mariadb /bin/bash

fclean: stop clean iclean vclean bclean

stop:
	@echo "Stopping services"
	@docker stop $(shell docker ps -aq)

clean:
	@echo "Removing unused images"
	@docker system prune --force

vclean:
	@echo "vclean: clean up docker volumes"
	@echo "> Removing docker volumes"
	@docker volume ls -q | xargs -r docker volume rm -f || echo "> No docker volumes to remove"
	@cd srcs && docker compose down -v

iclean:
	@echo "iclean: clean up unused docker images"
	@echo "> Removing docker images"
	@docker images -q | xargs -r docker rmi -f || echo "> No docker images to remove"

bclean:
	@echo "bclean: clean volume bindings"
	@echo "> Removing mariadb files from ~/data/mariadb dir"
	@sudo rm -rf ~/data/mariadb/*
	@echo ">Removing wordpress install from ~/data/wordpress dir"
	@sudo rm -f ~/data/wordpress/*

.PHONY: stop clean fclean vclean iclean wp_shell nginx_shell shell_db shell_ng shell_wp
