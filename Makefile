# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/28 11:31:22 by jcummins          #+#    #+#              #
#    Updated: 2024/11/15 18:42:16 by jcummins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
SRCS = srcs

all: $(NAME)

/srcs/.env:
	@echo "Copying .env file from secrets"
	@cp /home/${USER}/data/secrets/.env srcs/

$(NAME): /srcs/.env
	@echo "Building docker project $(NAME)"
	docker compose -f ./srcs/docker-compose.yaml up --build -d

re: /srcs/.env
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

evaluate:
	docker stop $(shell docker ps -qa)
	docker rm $(shell docker ps -qa)
	docker rmi -f $(shell docker images -qa)
	docker volume rm $(shell docker volume ls -q)
	docker network rm $(shell docker network ls -q)

top:
	@docker top nginx
	@docker top mariadb
	@docker top wordpress

shell_ng:
	docker exec -it nginx /bin/bash

shell_wp:
	docker exec -it wordpress /bin/bash

shell_db:
	docker exec -it mariadb /bin/bash

fclean: stop clean iclean vclean bclean eclean

stop:
	@echo "$@: Stopping services"
	@docker stop $(shell docker ps -aq)

clean:
	@echo "$@: Removing unused images"
	@docker system prune --force

eclean:
	@echo "$@: Removing .env file from local directory"
	@rm -f srcs/.env

vclean:
	@echo "$@: clean up docker volumes"
	@echo "> Removing docker volumes"
	@docker volume ls -q | xargs -r docker volume rm -f || echo "> No docker volumes to remove"
	@cd srcs && docker compose down -v

iclean:
	@echo "$@: clean up unused docker images"
	@echo "> Removing docker images"
	@docker images -q | xargs -r docker rmi -f || echo "> No docker images to remove"

bclean:
	@echo "$@: clean volume bindings"
	@echo "> Removing mariadb files from ~/data/mariadb dir"
	@sudo rm -rf ~/data/mariadb/*
	@echo "> Removing wordpress install from ~/data/wordpress dir"
	@sudo rm -rf ~/data/wordpress/*

.PHONY: stop clean fclean eclean bclean vclean iclean wp_shell nginx_shell shell_db shell_ng shell_wp
