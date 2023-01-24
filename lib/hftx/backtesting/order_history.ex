defmodule Hftx.Backtesting.OrderHistory do
  @moduledoc """
  Backtesting helper module that stores the order history
  """
  use Agent

  require Logger
  alias Hftx.Data.Agent.Suggestion

  @spec name(String.t()) :: atom()
  def name(symbol) do
    ("OrderHistory." <> symbol) |> String.to_atom()
  end

  @spec start_link(String.t()) :: {:error, any} | {:ok, pid}
  def start_link(symbol) do
    Agent.start_link(fn -> [] end, name: symbol |> name())
  end

  @spec place_order(String.t(), {Suggestion.t(), float()}) :: :ok
  def place_order(symbol, {order_type, current_price}) do
    Agent.update(symbol |> name(), fn ord_hist ->
      [{order_type, current_price} | ord_hist]
    end)
  end

  @spec statement(String.t()) :: map()
  def statement(symbol) do
    symbol
    |> name()
    |> Agent.get(fn state -> state end)
    |> Enum.reverse()
    |> Enum.reduce(
      %{num_stock: 0, cost: 0, profit: 0},
      fn {order_type, price}, %{num_stock: s, cost: c, profit: p} ->
        case order_type do
          :long -> %{num_stock: s + 1, cost: c + price, profit: p}
          :short -> %{num_stock: 0, cost: 0, profit: s * price + p - c}
        end
      end
    )
  end
end
