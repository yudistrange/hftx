defmodule Hftx.Zerodha.WebSocket.FrameTest do
  use ExUnit.Case

  alias Hftx.Zerodha.WebSocket.Frame

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
    num_packet = 1
    packet_size = 8
    instrument_token = 111_111
    ltp = 100

    msg = <<num_packet::16, packet_size::16, instrument_token::32, ltp::32>>
    assert Frame.parse(msg) === {:market_event, [%{instrument_token: instrument_token, ltp: ltp}]}
  end
end
