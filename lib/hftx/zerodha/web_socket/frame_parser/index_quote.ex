defmodule Hftx.Zerodha.WebSocket.FrameParser.IndexQuote do
  @moduledoc """
  Handles parsing index of type `Quote`
  """
  require Logger
  alias Hftx.Data.IndexEvent

  @size 28
  def size(), do: @size

  @spec parse(binary) :: {:ok, IndexEvent.t()} | {:error, :parse_error}
  def parse(
        <<instrument_token::32, ltp::32, high_price::32, low_price::32, open_price::32,
          close_price::32, price_change::32>>
      ) do
    {:ok,
     %IndexEvent{
       timestamp: DateTime.utc_now(),
       # TODO: Fetch symbol from the instruments table
       symbol: "",
       instrument_token: instrument_token,
       last_trade_price: ltp,
       high_price: high_price,
       low_price: low_price,
       open_price: open_price,
       close_price: close_price,
       price_change: price_change
     }}
  end

  @spec parse(binary) :: {:ok, IndexEvent.t()} | {:error, :parse_error}
  def parse(_msg) do
    Logger.error("Index Quote message could not be parsed")
    {:error, :parse_error}
  end
end
