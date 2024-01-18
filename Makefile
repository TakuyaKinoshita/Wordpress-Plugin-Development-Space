# Makefile
include .env
export
down:
	docker-compose down --rmi all --volumes --remove-orphans
up:
	docker-compose up -d
up-build:
	docker-compose up -d --build
build:
	docker-compose build --no-cache
start:
	docker-compose start
stop:
	docker-compose stop
log:
	docker-compose logs
init:
	rm -rf wordpress/*
	rm -rf src/backend/*
	rm -rf src/frontend/*
	rm -rf docker/nginx/logs/*
	@make down
	@make up-build
createblock-%:
	docker exec -it ${PREFIX}_node npx @wordpress/create-block $(filter-out $@,$(MAKECMDGOALS)) /${VUE_ROOT_DIR}
	docker exec -it ${PREFIX}_web cp -r /tmp/src/frontend/$(filter-out $@,$(MAKECMDGOALS)) ${NGINX_ROOT_DIR}/${WORDPRESS_INSTALL_DIR}/wp-content/${WORDPRESS_DEVELOP_MODE}
	docker exec -it ${PREFIX}_web ln -s ${NGINX_ROOT_DIR}/${WORDPRESS_INSTALL_DIR}/wp-content/${WORDPRESS_DEVELOP_MODE}/$(filter-out $@,$(MAKECMDGOALS)) /tmp/src/frontend/$(filter-out $@,$(MAKECMDGOALS))
