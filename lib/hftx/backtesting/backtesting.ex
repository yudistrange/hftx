defmodule Hftx.Backtesting do
  @moduledoc """
  This is a collection of modules that help run a backtest for a set of strategies
  against a historical market data of an instrument
  """
  require Logger
  alias Hftx.Backtesting.PriceTracker
  alias Hftx.Backtesting.OrderHistory
  alias Hftx.Backtesting.Runner

  @symbol "bajfinance"
  @instrument_token 123

  def run(_) do
    Logger.info("Launch the backtester process asynchronously")

    Task.start(fn ->
      # Start OrderHistory Agent
      OrderHistory.start_link(@symbol)

      # Start PriceTracker Agent
      PriceTracker.start_link(@symbol)

      # Sleep for 10 seconds for other processes to boot up
      :timer.sleep(10000)

      # Start the backtest runner
      Runner.run({@symbol, @instrument_token})
    end)
  end
end
