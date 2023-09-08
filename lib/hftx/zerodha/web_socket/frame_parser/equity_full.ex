defmodule Hftx.Zerodha.WebSocket.FrameParser.EquityFull do
  @moduledoc """
  Handles parsing equity message of type `Full`
  """
  require Logger
  alias Hftx.Data.MarketEvent

  @size 44
  def size(), do: @size

  @spec parse(binary) :: {:ok, MarketEvent.t()} | {:error, :parse_error}
  def parse(_msg) do
    Logger.error("Equity Full message parsing is not implemented")
    {:error, :parse_error}
  end
end
