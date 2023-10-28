defmodule Hftx.Zerodha.WebSocket.FrameParser.EquityQuoteTest do
  use ExUnit.Case

  alias Hftx.Zerodha.WebSocket.FrameParser.EquityQuote
  alias Hftx.Data.EquityEvent

  test "Parse an Equity LTP message of size 64 bytes" do
    quote_msg =
      <<0, 6, 58, 1, 0, 2, 32, 141, 0, 0, 0, 97, 0, 2, 29, 80, 0, 56, 101, 31, 0, 3, 125, 117, 0,
        4, 106, 217, 0, 2, 30, 38, 0, 2, 32, 236, 0, 2, 25, 228, 0, 2, 26, 107>>

    frozen_ts = DateTime.utc_now()
    {:ok, market_event} = EquityQuote.parse(quote_msg)

    assert market_event |> Map.put(:timestamp, frozen_ts) === %EquityEvent{
             average_price: 138_576,
             close_price: 137_835,
             high_price: 139_500,
             instrument_token: 408_065,
             last_trade_price: 139_405,
             last_trade_volume: 97,
             low_price: 137_700,
             open_price: 138_790,
             order_book: nil,
             symbol: "",
             total_buy_calls: 228_725,
             total_sell_calls: 289_497,
             total_trade_calls: nil,
             total_trade_volume: 3_695_903,
             timestamp: frozen_ts
           }
  end

  test "Fail for a message of any other size" do
    msg = <<0>>
    assert EquityQuote.parse(msg) === {:error, :parse_error}
  end
end
