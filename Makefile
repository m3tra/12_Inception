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
	@mkdir $HOME/data
	@mkdir $HOME/data/mariadb
	@mkdir $HOME/data/website-root
	@mkdir $HOME/data/nginx
	@mkdir $HOME/data/ssl
	@mkdir $HOME/data/redis_log
	@mkdir $HOME/data/redis_db
	@mkdir $HOME/data/vsftpd
	@mkdir $HOME/data/uptime-kuma
	@docker compose -f srcs/docker-compose.yml up -d

down:
	@printf $(YELLOW)"Stopping"$(WHITE)" containers\n"
	@docker compose -f srcs/docker-compose.yml down

logs:
	@docker compose --env-file=srcs/.env -f=srcs/docker-compose.yml logs -f

backup:
	@sudo cp -rfT ~/data ~/data_bak

restore:
	@sudo cp -rT ~/data_bak ~/data

re:
	@printf $(GREEN)"Starting/Rebuilding"$(WHITE)" containers\n"
	@docker compose -f srcs/docker-compose.yml up -d --build

clean:
	@printf $(YELLOW)"Stopping"$(WHITE)" containers\n"
	-@docker ps -aq | xargs docker stop 2>/dev/null | xargs docker rm 2>/dev/null

	@printf $(RED)"Removing"$(WHITE)" images\n"
	-@docker images -qa | xargs docker rmi -f 2>/dev/null

	@printf $(RED)"Removing"$(WHITE)" volumes\n"
	-@docker volume ls -q | xargs docker volume rm 2>/dev/null
	-@sudo rm -rf /home/fporto/data/

	@printf $(RED)"Removing"$(WHITE)" networks\n"
	-@docker network ls -q | xargs docker network rm 2>/dev/null

fclean: clean
	@docker system prune -af
	@printf $(RED)"Removing"$(PURPLE)" ~/data"$(WHITE)" directory\n"
	@rm -rf $HOME/data/*/*

.PHONY: all up down re clean fclean
