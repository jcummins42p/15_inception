# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcummins <jcummins@student.42prague.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/28 11:31:22 by jcummins          #+#    #+#              #
#    Updated: 2024/11/08 19:31:40 by jcummins         ###   ########.fr        #
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

fclean: stop clean iclean vclean

stop:
	@echo "Stopping services"
	@docker stop $(shell docker ps -aq)

clean:
	@echo "Removing unused images"
	@docker system prune --force

crapvclean:
	@echo "Removing docker volumes"
	@volumes=$(shell docker volume ls -q)
	@echo "$$volumes"
	@if [ -n "$$volumes" ]; then \
		@for volume in volumes; do \
			@echo "> Removing volume $$volume"; \
			docker volume rm $$volume; \
		done \
	else \
		@echo "> No docker images to remove";\
	fi

vclean:
	@echo "Removing docker volumes"
	@docker volume ls -q | xargs -r docker volume rm -f || echo "> No docker volumes to remove"

iclean:
	@echo "Removing docker images"
	@docker images -q | xargs -r docker rmi -f || echo "> No docker images to remove"

crapiclean:
	@echo "Removing docker images"
	@images=$(shell docker images -q)
	@echo $$images
	@for image in images; do \
		echo "> Removing docker image $$image"; \
		docker image rm $$image; \
	done

.PHONY: stop clean fclean vclean iclean wp_shell nginx_shell shell_db shell_ng shell_wp
