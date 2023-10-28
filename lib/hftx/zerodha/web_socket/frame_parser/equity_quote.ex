defmodule Hftx.Zerodha.WebSocket.FrameParser.EquityQuote do
  @moduledoc """
  Handles parsing an equity packet of mode `Quote`
  """
  require Logger
  alias Hftx.Data.EquityEvent

  @size 44
  def size(), do: @size

  @spec parse(binary) :: {:ok, EquityEvent.t()} | {:error, :parse_error}
  def parse(
        <<instrument_token::32, ltp::32, last_trade_volume::32, average_price::32,
          total_trade_volume::32, total_buy::32, total_sell::32, open_price::32, high_price::32,
          low_price::32, close_price::32>>
      ) do
    {:ok,
     %EquityEvent{
       timestamp: DateTime.utc_now(),
       # TODO: Fetch symbol from the instruments table
       symbol: "",
       instrument_token: instrument_token,
       last_trade_price: ltp,
       last_trade_volume: last_trade_volume,
       average_price: average_price,
       total_trade_volume: total_trade_volume,
       total_buy_calls: total_buy,
       total_sell_calls: total_sell,
       open_price: open_price,
       high_price: high_price,
       low_price: low_price,
       close_price: close_price
     }}
  end

  def parse(_msg) do
    Logger.error("Received a message of incorrect size in EquityQuote message")
    {:error, :parse_error}
  end
end
