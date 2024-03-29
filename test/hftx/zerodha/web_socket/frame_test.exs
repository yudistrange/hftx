defmodule Hftx.Zerodha.WebSocket.FrameTest do
  use ExUnit.Case

  alias Hftx.Zerodha.WebSocket.Frame
  alias Hftx.Data.EquityEvent
  alias Hftx.Data.IndexEvent

  @ltp_frame <<0, 1, 0, 8, 0, 13, 128, 1, 0, 0, 238, 22>>

  @quote_frame <<0, 1, 0, 44, 0, 6, 58, 1, 0, 2, 32, 141, 0, 0, 0, 97, 0, 2, 29, 80, 0, 56, 101,
                 31, 0, 3, 125, 117, 0, 4, 106, 217, 0, 2, 30, 38, 0, 2, 32, 236, 0, 2, 25, 228,
                 0, 2, 26, 107>>

  @full_frame <<0, 1, 0, 184, 0, 6, 58, 1, 0, 2, 32, 36, 0, 0, 0, 5, 0, 2, 29, 87, 0, 56, 230,
                197, 0, 0, 0, 0, 0, 0, 4, 216, 0, 2, 30, 38, 0, 2, 32, 236, 0, 2, 25, 228, 0, 2,
                26, 107, 100, 208, 199, 122, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 208, 238,
                145, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 216, 0, 2, 32, 36, 0, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>

  @index_quote_frame <<0, 1, 0, 28, 0, 6, 58, 1, 0, 2, 32, 141, 0, 2, 33, 141, 0, 2, 29, 80, 0, 2,
                       30, 31, 0, 2, 31, 117, 0, 0, 106, 217>>

  @index_full_frame <<0, 1, 0, 32, 0, 6, 58, 1, 0, 2, 32, 141, 0, 2, 33, 141, 0, 2, 29, 80, 0, 2,
                      30, 31, 0, 2, 31, 117, 0, 0, 106, 217, 1, 0, 106, 5>>

  test "Parse single byte frame as hearbeat" do
    msg = <<1::8>>
    assert Frame.parse(msg) === :heartbeat
  end

  test "Parse Json formatted string frame as user_event" do
    msg = "{\"name\": \"hftx\"}"
    decoded_msg = msg |> Jason.decode!()
    assert Frame.parse(msg) === {:user_event, decoded_msg}
  end

  test "Parse binary ltp message as market_event" do
    {:market_event, [parsed_msg]} = Frame.parse(@ltp_frame)

    assert parsed_msg |> Map.get(:instrument_token) === 884_737
    assert parsed_msg |> Map.get(:last_trade_price) === 60_950
  end

  test "Parse binary quote message as market_event" do
    {:market_event, [parsed_msg]} = Frame.parse(@quote_frame)

    assert parsed_msg |> Map.get(:instrument_token) === 408_065
    assert parsed_msg |> Map.get(:last_trade_price) === 139_405
    assert parsed_msg |> Map.get(:last_trade_volume) === 97
    assert parsed_msg |> Map.get(:average_price) === 138_576
    assert parsed_msg |> Map.get(:total_trade_volume) === 3_695_903
    assert parsed_msg |> Map.get(:total_buy_calls) === 228_725
    assert parsed_msg |> Map.get(:total_sell_calls) === 289_497
    assert parsed_msg |> Map.get(:open_price) === 138_790
    assert parsed_msg |> Map.get(:high_price) === 139_500
    assert parsed_msg |> Map.get(:low_price) === 137_700
    assert parsed_msg |> Map.get(:close_price) === 137_835
  end

  test "Parse binary full message as market_event" do
    frozen_ts = DateTime.utc_now()
    {:market_event, [market_event]} = Frame.parse(@full_frame)

    assert market_event |> Map.put(:timestamp, frozen_ts) === %EquityEvent{
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
             order_book: %Hftx.Data.EquityEvent.OrderBook{
               bid: [
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0}
               ],
               offer: [
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{
                   quantity: 1240,
                   orders: 28,
                   price: 139_300
                 },
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0},
                 %Hftx.Data.EquityEvent.OrderBook.OrderTuple{quantity: 0, orders: 0, price: 0}
               ]
             }
           }
  end

  test "Parse Index Quote message as market_event" do
    frozen_ts = DateTime.utc_now()
    {:market_event, [market_event]} = Frame.parse(@index_quote_frame)

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

  test "Parse Index Full message as market_event" do
    frozen_ts = DateTime.utc_now()
    {:market_event, [market_event]} = Frame.parse(@index_full_frame)

    assert market_event |> Map.put(:timestamp, frozen_ts) === %IndexEvent{
             instrument_token: 408_065,
             last_trade_price: 139_405,
             high_price: 139_661,
             low_price: 138_576,
             open_price: 138_783,
             close_price: 139_125,
             price_change: 27_353,
             exchange_timestamp: 16_804_357,
             symbol: "",
             timestamp: frozen_ts
           }
  end

  test "Parse multiple LTP messages" do
    ltp_frames = <<0, 2, 0, 8, 0, 13, 128, 1, 0, 0, 238, 22, 0, 8, 0, 13, 128, 1, 0, 0, 238, 22>>
    frozen_ts = DateTime.utc_now()
    instrument_token = 884_737
    ltp = 60_950

    {:market_event, market_events} = Frame.parse(ltp_frames)
    assert Enum.count(market_events) == 2

    assert Enum.at(market_events, 0) |> Map.put(:timestamp, frozen_ts) == %EquityEvent{
             timestamp: frozen_ts,
             symbol: "",
             instrument_token: instrument_token,
             last_trade_price: ltp
           }

    assert Enum.at(market_events, 1) |> Map.put(:timestamp, frozen_ts) == %EquityEvent{
             timestamp: frozen_ts,
             symbol: "",
             instrument_token: instrument_token,
             last_trade_price: ltp
           }
  end

  test "Parse equity and index messages from same frame" do
    mixed_frames =
      <<0, 2, 0, 8, 0, 13, 128, 1, 0, 0, 238, 22, 0, 28, 0, 6, 58, 1, 0, 2, 32, 141, 0, 2, 33,
        141, 0, 2, 29, 80, 0, 2, 30, 31, 0, 2, 31, 117, 0, 0, 106, 217>>

    frozen_ts = DateTime.utc_now()
    instrument_token = 884_737
    ltp = 60_950

    {:market_event, market_events} = Frame.parse(mixed_frames)
    assert Enum.count(market_events) == 2

    assert Enum.at(market_events, 0) |> Map.put(:timestamp, frozen_ts) === %IndexEvent{
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

    assert Enum.at(market_events, 1) |> Map.put(:timestamp, frozen_ts) == %EquityEvent{
             timestamp: frozen_ts,
             symbol: "",
             instrument_token: instrument_token,
             last_trade_price: ltp
           }
  end
end
