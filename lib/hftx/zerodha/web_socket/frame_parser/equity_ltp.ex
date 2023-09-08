defmodule Hftx.Zerodha.WebSocket.FrameParser.EquityLtp do
  @moduledoc """
  Handles parsing index and equity message of type `LTP`
  """
  require Logger
  alias Hftx.Data.MarketEvent

  @size 8
  def size(), do: @size

  @spec parse(binary) :: {:ok, MarketEvent.t()} | {:error, :parse_error}
  def parse(<<instrument_token::32, ltp::32>>) do
    {:ok,
     %MarketEvent{
       timestamp: DateTime.utc_now(),
       # TODO: Fetch the symbol for the instrument_token
       symbol: "",
       instrument_token: instrument_token,
       last_trade_price: ltp
     }}
  end

  def parse(msg) do
    Logger.error(
      "Received a message of incorrect size in EquityLTP message, #{:binary.bin_to_list(msg)}"
    )

    {:error, :parse_error}
  end
end
