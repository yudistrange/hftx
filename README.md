# Hftx ![example workflow](https://github.com/yudistrange/hftx/actions/workflows/dialyzer.yaml/badge.svg)

Automated trading platform written with Elixir. It uses zerodha's kite trading APIs to track market and place orders.

## Architecture

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
