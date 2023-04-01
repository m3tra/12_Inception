up:
	@docker-compose -f ./srcs/docker-compose.yml up

down:
	@docker-compose -f ./srcs/docker-compose.yml down

all: up

re:
	@docker-compose -f srcs/docker-compose.yml up -d --build

clean:
	@docker stop $(docker ps -qa) 2>/dev/null
	@docker rm $(docker ps -qa) 2>/dev/null
	@docker rmi -f $(docker images -qa) 2>/dev/null
	@docker volume rm $(docker volume ls -q) 2>/dev/null
	@docker network rm $(docker network ls -q) 2>/dev/null

fclean: clean
	@rm -rf $HOME/data

.PHONY: all re down clean fclean
