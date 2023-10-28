defmodule Hftx.Zerodha.WebSocket.FrameParser.EquityLtpTest do
  use ExUnit.Case

  alias Hftx.Zerodha.WebSocket.FrameParser.EquityLtp
  alias Hftx.Data.EquityEvent

  test "Parse an Equity LTP message of size 64 bytes" do
    ltp_msg = <<0, 13, 128, 1, 0, 0, 238, 22>>
    frozen_ts = DateTime.utc_now()
    {:ok, market_event} = EquityLtp.parse(ltp_msg)

    assert market_event |> Map.put(:timestamp, frozen_ts) === %EquityEvent{
             timestamp: frozen_ts,
             # TODO: Fetch the symbol for the instrument_token
             symbol: "",
             instrument_token: 884_737,
             last_trade_price: 60_950
           }
  end

  test "Fail for a message of any other size" do
    msg = <<0>>
    assert EquityLtp.parse(msg) === {:error, :parse_error}
  end
end
