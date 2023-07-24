defmodule Hftx.Data.Trader.Suggestion do
  @type t :: :long | :short | :hold

  def long, do: :long
  def short, do: :short
  def hold, do: :hold
end
