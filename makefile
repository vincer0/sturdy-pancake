# Variables
ENV_FILE=./docker/.env
COMPOSE_FILE=./docker-compose.yml
COMPOSE=docker compose --env-file=$(ENV_FILE) -f $(COMPOSE_FILE)
ARGS=

# Targets
build:
	$(COMPOSE) build $(ARGS)

up:
	$(COMPOSE) up $(ARGS)

down:
	$(COMPOSE) down $(ARGS)

logs:
	$(COMPOSE) logs -f $(ARGS)

ps:
	$(COMPOSE) ps $(ARGS)

stop:
	$(COMPOSE) stop $(ARGS)

restart:
	$(COMPOSE) restart $(ARGS)

app_bash:
	$(COMPOSE) exec app bash $(ARGS)

mariadb_bash:
	$(COMPOSE) exec mariadb bash $(ARGS)

frontend_bash:
	$(COMPOSE) exec frontend bash $(ARGS)

migrate:
	$(COMPOSE) exec app php artisan migrate $(ARGS)

init:
	cp .env.example .env
	cp docker/.env.example docker/.env
	cp docker/mariadb/docker-entrypoint-initdb.d/createdb.sql.example docker/mariadb/docker-entrypoint-initdb.d/createdb.sql
	cp docker/app/supervisord.d/laravel-horizon.conf.example docker/app/supervisord.d/laravel-horizon.conf
	cp docker/app/supervisord.d/laravel-phpfpm.conf.example docker/app/supervisord.d/laravel-phpfpm.conf
	cp docker/app/supervisord.d/laravel-scheduler.conf.example docker/app/supervisord.d/laravel-scheduler.conf

setup:
	$(COMPOSE) exec app composer install -o $(ARGS)
	$(COMPOSE) exec app php artisan migrate $(ARGS)
	$(COMPOSE) exec app php artisan key:generate $(ARGS)
	$(COMPOSE) restart
