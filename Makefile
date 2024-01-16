reset:
	docker compose down --rmi all --volumes --remove-orphans;
up:
	docker compose up -d --build
log:
	docker compose logs