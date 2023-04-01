up:
	@docker-compose -f ./srcs/docker-compose.yml up

down:
	@docker-compose -f ./srcs/docker-compose.yml down

all: up

re:
	@docker-compose -f srcs/docker-compose.yml up -d --build

clean:
#	@docker stop $(docker ps -qa) > /dev/null
#	@docker rm $(docker ps -qa) > /dev/null
	docker ps -aq | xargs docker stop | xargs docker rm

#	@docker rmi -f $(docker images -qa) > /dev/null
	docker images -qa | xargs docker rmi -f

#	@docker volume rm $(docker volume ls -q) > /dev/null
	docker volume ls -q | xargs docker volume rm

#	@docker network rm $(docker network ls -q) > /dev/null
	docker network ls -q | xargs docker network rm

fclean: clean
	@rm -rf $HOME/data

.PHONY: all re down clean fclean
