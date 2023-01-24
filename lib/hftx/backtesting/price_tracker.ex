defmodule Hftx.Backtesting.PriceTracker do
  @moduledoc """
  Backtesting helper module to track the current price of the stock
  """
  use Agent

  @spec name(String.t()) :: atom()
  def name(symbol) do
    ("PriceTracker." <> symbol) |> String.to_atom()
  end

  @spec start_link(String.t()) :: {:error, any} | {:ok, pid}
  def start_link(symbol) do
    Agent.start_link(fn -> 0 end, name: symbol |> name())
  end

  def current_price(symbol) do
    Agent.get(symbol |> name(), fn price -> price end)
  end

  def update(symbol, current_price) do
    Agent.update(symbol |> name(), fn _ -> current_price end)
  end
end
