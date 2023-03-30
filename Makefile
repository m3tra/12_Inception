up:
	@docker-compose -f ./srcs/docker-compose.yml up

down:
	@docker-compose -f ./srcs/docker-compose.yml down

all: up

re:
	@docker-compose -f srcs/docker-compose.yml up -d --build

clean:
	@docker stop $(docker ps -qa)
	@docker rm $(docker ps -qa)
	@docker rmi -f $(docker images -qa)
	@docker volume rm $(docker volume ls -q)
	@docker network rm $(docker network ls -q)

fclean: clean
	@rm -rf $HOME/data

.PHONY: all re down clean fclean
