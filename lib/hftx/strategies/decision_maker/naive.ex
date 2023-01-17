defmodule Hftx.Strategies.DecisionMaker.Naive do
  @moduledoc """
  Naive strategy - FOR TESTING PURPOSE ONLY

  Decide on the first agent's response
  """
  @behaviour Hftx.Strategies.DecisionMaker

  @impl true
  def decide([suggestion | _rest]) do
    suggestion
  end
end
