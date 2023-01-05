defmodule Hftx.Data.Agent.State do
  @moduledoc """
  Struct to represent the state of an agent worker
  """
  @enforce_keys [:strategy, :symbol]
  defstruct [:name, :strategy, :symbol, events: [], trades: []]

  @type t :: %__MODULE__{
          name: String.t(),
          strategy: module,
          symbol: String.t(),
          events: [Events.t()],
          trades: [Trades.t()]
        }

  defmodule Events do
    @enforce_keys [:timestamp, :price]
    defstruct [:timestamp, :price]

    @type t :: %__MODULE__{
            timestamp: non_neg_integer(),
            price: float()
          }
  end

  defmodule Trades do
    @enforce_keys [:count, :price, :type]
    defstruct [:count, :price, :type]

    @type t :: %__MODULE__{
            count: non_neg_integer(),
            price: float(),
            type: Buy | Sell
          }
  end
end
