defmodule Hftx.Strategies.Trader.AlwaysLong do
  @moduledoc """
  TraderStrategy that always goes :long

  THIS IS FOR TESTNIG PURPOSE ONLY
  """
  @behaviour Hftx.Strategies.Trader

  alias Hftx.Data.Trader.Suggestion, as: TraderSuggestion

  @impl true
  def historical_event_window(), do: 50

  @impl true
  def evaluate(_previous_suggestion, market_history) do
    {TraderSuggestion.long(), market_history |> Enum.take(historical_event_window())}
  end
end
