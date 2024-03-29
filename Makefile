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

analyze:
	mix credo

backtest: export MIX_ENV = backtest
backtest:
	echo "Launching Shell for backtesting"
	iex -S mix
