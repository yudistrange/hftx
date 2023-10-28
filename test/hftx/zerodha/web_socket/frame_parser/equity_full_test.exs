defmodule Hftx.Zerodha.WebSocket.FrameParser.EquityFulltest do
  use ExUnit.Case

  alias Hftx.Zerodha.WebSocket.FrameParser.EquityFull
  alias Hftx.Data.MarketEvent

  test "Parse an Equity LTP message of size 64 bytes" do
    full_msg =
      <<0, 6, 58, 1, 0, 2, 32, 36, 0, 0, 0, 5, 0, 2, 29, 87, 0, 56, 230, 197, 0, 0, 0, 0, 0, 0, 4,
        216, 0, 2, 30, 38, 0, 2, 32, 236, 0, 2, 25, 228, 0, 2, 26, 107, 100, 208, 199, 122, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 208, 238, 145, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 216, 0, 2, 32, 36, 0, 28, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>

    frozen_ts = DateTime.utc_now()
    {:ok, market_event} = EquityFull.parse(full_msg)

    assert market_event |> Map.put(:timestamp, frozen_ts) === %MarketEvent{
             average_price: 138_583,
             close_price: 137_835,
             high_price: 139_500,
             instrument_token: 408_065,
             last_trade_price: 139_300,
             last_trade_volume: 5,
             low_price: 137_700,
             open_price: 138_790,
             symbol: "",
             total_buy_calls: 0,
             total_sell_calls: 1240,
             total_trade_calls: nil,
             total_trade_volume: 3_729_093,
             timestamp: frozen_ts,
             last_trade_timestamp: 1_691_404_154,
             open_interest: 0,
             open_interest_day_high: 0,
             open_interest_day_low: 0,
             exchange_timestamp: 1_691_414_161,
             order_book: %Hftx.Data.MarketEvent.OrderBook{
               bid: [
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0}
               ],
               offer: [
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{
                   quantity: 1240,
                   orders: 28,
                   price: 139_300
                 },
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.MarketEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0}
               ]
             }
           }
  end

  test "Fail for a message of any other size" do
    msg = <<0>>
    assert EquityFull.parse(msg) === {:error, :parse_error}
  end
end
