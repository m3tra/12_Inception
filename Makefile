MAKEFLAGS += --silent

# Color codes
WHITE	:=	"\033[0m"
RED		:=	"\033[38;5;1m"
GREEN	:=	"\033[38;5;47m"
BLUE	:=	"\033[38;5;14m"
YELLOW	:=	"\033[33m"
PURPLE	:=	"\033[38;5;13m"

all: up

up:
	@printf $(GREEN)"Starting"$(WHITE)" containers\n"
	@docker compose -f srcs/docker-compose.yml up

down:
	@printf $(YELLOW)"Stopping"$(WHITE)" containers\n"
	@docker compose -f srcs/docker-compose.yml down

re:
	@printf $(GREEN)"Starting/Rebuilding"$(WHITE)" containers\n"
	@docker compose -f srcs/docker-compose.yml up -d --build

clean:
	@printf $(YELLOW)"Stopping"$(WHITE)" containers\n"
	@docker ps -aq | xargs docker stop | xargs docker rm
#	@docker stop $(docker ps -qa) > /dev/null
#	@docker rm $(docker ps -qa) > /dev/null

	@printf $(RED)"Removing"$(WHITE)" images\n"
	@docker images -qa | xargs docker rmi -f
#	@docker rmi -f $(docker images -qa) > /dev/null

#	@printf $(RED)"Removing"$(WHITE)" volumes\n"
#	@docker volume ls -q | xargs docker volume rm
#	@docker volume rm $(docker volume ls -q) > /dev/null

	@printf $(RED)"Removing"$(WHITE)" networks\n"
	@docker network ls -q | xargs docker network rm
#	@docker network rm $(docker network ls -q) > /dev/null

fclean: clean
	@docker prune images -af
	@printf $(RED)"Removing"$(PURPLE)" ~/data"$(WHITE)" directory\n"
	@rm -rf $HOME/data

.PHONY: all up down re clean fclean
