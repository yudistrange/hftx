defmodule Hftx.Zerodha.WebSocket.FrameParser.IndexQuoteTest do
  use ExUnit.Case

  alias Hftx.Zerodha.WebSocket.FrameParser.IndexQuote
  alias Hftx.Data.IndexEvent

  test "Parse an Index LTP message of size 28 bytes" do
    quote_msg =
      <<0, 6, 58, 1, 0, 2, 32, 141, 0, 2, 33, 141, 0, 2, 29, 80, 0, 2, 30, 31, 0, 2, 31, 117, 0,
        0, 106, 217>>

    frozen_ts = DateTime.utc_now()
    {:ok, market_event} = IndexQuote.parse(quote_msg)

    assert market_event |> Map.put(:timestamp, frozen_ts) === %IndexEvent{
             instrument_token: 408_065,
             last_trade_price: 139_405,
             high_price: 139_661,
             low_price: 138_576,
             open_price: 138_783,
             close_price: 139_125,
             price_change: 27_353,
             symbol: "",
             timestamp: frozen_ts
           }
  end

  test "Fail for a message of any other size" do
    msg = <<0>>
    assert IndexQuote.parse(msg) === {:error, :parse_error}
  end
end
