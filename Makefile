run:
	docker compose -f dev/docker-compose.yaml up -d
	mix phx.server
