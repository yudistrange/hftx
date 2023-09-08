defmodule Hftx.Zerodha.WebSocket.FrameTest do
  use ExUnit.Case

  alias Hftx.Zerodha.WebSocket.Frame

  @quote_frame <<0, 1, 0, 44, 0, 6, 58, 1, 0, 2, 32, 141, 0, 0, 0, 97, 0, 2, 29, 80, 0, 56, 101,
                 31, 0, 3, 125, 117, 0, 4, 106, 217, 0, 2, 30, 38, 0, 2, 32, 236, 0, 2, 25, 228,
                 0, 2, 26, 107>>

  @ltp_frame <<0, 1, 0, 8, 0, 13, 128, 1, 0, 0, 238, 22>>

  @full_frame <<0, 1, 0, 184, 0, 6, 58, 1, 0, 2, 32, 36, 0, 0, 0, 5, 0, 2, 29, 87, 0, 56, 230,
                197, 0, 0, 0, 0, 0, 0, 4, 216, 0, 2, 30, 38, 0, 2, 32, 236, 0, 2, 25, 228, 0, 2,
                26, 107, 100, 208, 199, 122, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 208, 238,
                145, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 216, 0, 2, 32, 36, 0, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>

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
    assert {:market_event, []} === Frame.parse(@full_frame)
  end
end
