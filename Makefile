.PHONY: test

run:
	docker compose -f dev/docker-compose.yaml up -d
	mix phx.server

test:
	docker compose -f dev/docker-test-compose.yaml up -d
	@echo "Waiting for Postgres to be ready..."

	@until docker exec -it hftx-test-db pg_isready -U postgres -d hftx_test -h localhost; do \
		echo "Waiting for database..."; \
		sleep 2; \
		done
	@echo "Postgres is up and running!"

	mix test
	docker compose -f dev/docker-test-compose.yaml down

typecheck:
	mix dialyzer --force-check

analyze:
	mix credo

backtest: export MIX_ENV = backtest
backtest:
	echo "Launching Shell for backtesting"
	iex -S mix
