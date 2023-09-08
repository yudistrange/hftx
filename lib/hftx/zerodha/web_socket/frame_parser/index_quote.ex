defmodule Hftx.Zerodha.WebSocket.FrameParser.IndexQuote do
  @moduledoc """
  Handles parsing index of type `Quote`
  """
  require Logger
  alias Hftx.Data.MarketEvent

  @size 28
  def size(), do: @size

  @spec parse(binary) :: {:ok, MarketEvent.t()} | {:error, :parse_error}
  def parse(_msg) do
    Logger.error("Index Quote message parsing is not implemented")
    {:error, :parse_error}
  end
end
