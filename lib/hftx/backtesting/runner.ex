defmodule Hftx.Backtesting.Runner do
  @moduledoc """
  Run a back test using downloaded historical market data
  """
  require Logger
  alias Hftx.Backtesting.PriceTracker
  alias Hftx.Workers.DataTransformer
  alias Hftx.Data.MarketEvent

  def run({symbol, instrument_token}) do
    Logger.info("Starting the backtester process")
    backtest_data = Application.get_env(:hftx, :backtest_data_file)

    File.stream!(backtest_data)
    # Drop the CSV Headers
    |> Stream.drop(1)
    |> Stream.map(fn line -> String.split(line, ",") end)
    |> Stream.filter(fn token -> not is_nil(token) end)
    |> Stream.map(fn tokens ->
      {ltp, _} = Enum.at(tokens, 1) |> Float.parse()

      %MarketEvent{
        timestamp: DateTime.utc_now() |> DateTime.to_unix(),
        last_trade_price: ltp,
        instrument_token: instrument_token,
        symbol: symbol
      }
    end)
    |> Stream.map(fn %{symbol: symbol, last_trade_price: ltp} = market_event ->
      # Update the current price
      PriceTracker.update(symbol, ltp)

      # Dispatch the market event for aggregation
      DataTransformer.observe(symbol, market_event)
    end)
    |> Stream.map(fn _ ->
      :timer.sleep(10)
    end)
    |> Stream.run()
  end
end
