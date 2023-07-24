defmodule Hftx.Data.Trader.State do
  @moduledoc """
  Struct to represent the state of an trader worker
  """
  alias Hftx.Data.Aggregate

  @enforce_keys [:strategy, :symbol]
  defstruct [:name, :strategy, :symbol, :instrument_id, events: []]

  @type t :: %__MODULE__{
          name: String.t(),
          strategy: module,
          symbol: String.t(),
          instrument_id: String.t(),
          events: [Aggregate.t()]
        }
end
