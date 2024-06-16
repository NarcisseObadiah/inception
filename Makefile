name = inception
compose_file = ./srcs/docker-compose.yml
env_file = srcs/.env
data_wp = ~/data/wordpress/*
data_db = ~/data/mariadb/*

all:
	@printf "Launch configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f $(compose_file) --env-file $(env_file) up -d

build:
	@printf "Building configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f $(compose_file) --env-file $(env_file) up -d --build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f $(compose_file) --env-file $(env_file) down

re: down
	@printf "Rebuild configuration ${name}...\n"
	@docker-compose -f $(compose_file) --env-file $(env_file) up -d --build

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a -f
	@sudo rm -rf $(data_wp)
	@sudo rm -rf $(data_db)

fclean:
	@printf "Total clean of all configurations docker\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf $(data_wp)
	@sudo rm -rf $(data_db)

.PHONY: all build down re clean fclean
