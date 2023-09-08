defmodule Hftx.Zerodha.WebSocket.FrameParser do
  @moduledoc """
  This module parses the market quote binary data packet
  into the MarketEvent struct
  """
  require Logger
  alias Hftx.Data.MarketEvent

  alias Hftx.Zerodha.WebSocket.FrameParser.EquityFull
  alias Hftx.Zerodha.WebSocket.FrameParser.EquityQuote
  alias Hftx.Zerodha.WebSocket.FrameParser.EquityLtp
  alias Hftx.Zerodha.WebSocket.FrameParser.IndexFull
  alias Hftx.Zerodha.WebSocket.FrameParser.IndexQuote

  @ltp_equity_size 8
  @quote_equity_size 44
  @full_equity_size 184

  @quote_index_size 28
  @full_index_size 32

  @spec parse(binary) :: {:ok, MarketEvent.t()} | {:error, :parse_error}
  def parse(<<packet_length::16, data::binary>> = packet) when is_binary(packet) do
    case packet_length do
      @ltp_equity_size ->
        Logger.info("Got Equity LTP message")
        EquityLtp.parse(data)

      @quote_equity_size ->
        Logger.info("Got Equity Quote message")
        EquityQuote.parse(data)

      @full_equity_size ->
        Logger.info("Got Equity Full message")
        EquityFull.parse(data)

      @quote_index_size ->
        Logger.info("Got Index Quote message")
        IndexQuote.parse(data)

      @full_index_size ->
        Logger.info("Got Index Full message")
        IndexFull.parse(data)

      _ ->
        Logger.error("Received unrecognized packet size")
        {:error, :parse_error}
    end
  end

  def parse(_packet) do
    Logger.error("Received unrecognized packet size which isn't binary")
    {:error, :parse_error}
  end
end
