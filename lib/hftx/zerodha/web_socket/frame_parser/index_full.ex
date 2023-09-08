defmodule Hftx.Zerodha.WebSocket.FrameParser.IndexFull do
  @moduledoc """
  Handles parsing index message of type `Full`
  """
  require Logger
  alias Hftx.Data.MarketEvent

  @size 32
  def size(), do: @size

  @spec parse(binary) :: {:ok, MarketEvent.t()} | {:error, :parse_error}
  def parse(_msg) do
    Logger.error("Index Full message parsing is not implemented")
    {:error, :parse_error}
  end
end
