down:
	docker compose down --rmi all --volumes --remove-orphans;
up:
	docker compose up -d
up-build:
	docker compose up -d --build
build:
	docker compose build --no-cache
start:
	docker compose start
stop:
	docker compose stop
log:
	docker compose logs
init:
	rm -rf src/backend/*
	rm -rf docker/nginx/logs/*
	@make down
	@make up-build