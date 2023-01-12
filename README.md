# Hftx
![dialyzer badge](https://github.com/yudistrange/hftx/actions/workflows/dialyzer.yaml/badge.svg)
![test badge](https://github.com/yudistrange/hftx/actions/workflows/test.yaml/badge.svg)


Automated trading platform written with Elixir. It uses zerodha's kite trading APIs to track market and place orders.

## Architecture

This diagram describes Hftx's architecture at a high level.

<p align="center">
  <img src="docs/hftx.png" width="640">
</p>

### Market event ingestion
- Ingests market event data over a websocket connection
- Parses the binary data into [internal struct representation](lib/hftx/data/market/event.ex)

### Data aggregation
- Collates the incoming market data into [aggregate struct](lib/hftx/data/aggregate/aggregate.ex)

### Agent Processes
- Each process represents a trader running an algorithm on one market instrument
- At any given moment there can be one or more agent processes for one market instrument
- Each process maintains a list of past market events, that help it run the algorithm

### Decision Maker
- This module accumulates the output on individual `agents`
- Makes the final decision of buy | sell | hold based on the accumulated data
- Calls the exchange to place the order
- Asynchronously adds the decision to database for analytics

## Configuration
## Local setup
- Install [docker](https://www.docker.com/products/docker-desktop/)
- Install [elixir](https://elixir-lang.org/install.html) v1.12 or later
  - [asdf](https://asdf-vm.com/) is a good tool for managing multiple versions of elixir (and other languages for that matter)

Once the local dependencies are met, run the following:

``` sh
make run
```

## Testing
``` sh
make test
```
