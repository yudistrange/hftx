.PHONY: test

run:
	docker compose -f dev/docker-compose.yaml up -d
	mix phx.server

test:
	docker compose -f dev/docker-test-compose.yaml up -d
	mix test
	docker compose -f dev/docker-test-compose.yaml down

typecheck:
	mix dialyzer --force-check
