up:
	@docker-compose -f ./srcs/docker-compose.yml up

down:
	@docker-compose -f ./srcs/docker-compose.yml down

all: up

re:
	@docker-compose -f srcs/docker-compose.yml up -d --build

clean:
	@docker stop $(docker ps -qa) > /dev/null
	@docker rm $(docker ps -qa) > /dev/null
	@docker rmi -f $(docker images -qa) > /dev/null
	@docker volume rm $(docker volume ls -q) > /dev/null
	@docker network rm $(docker network ls -q) > /dev/null

fclean: clean
	@rm -rf $HOME/data

.PHONY: all re down clean fclean
