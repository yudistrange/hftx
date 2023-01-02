defmodule Hftx.Agent.State do
  @enforce_keys [:strategy, :symbol]
  defstruct [:name, :strategy, :symbol, events: [], trades: []]

  @type t :: %__MODULE__{
          name: String.t(),
          strategy: String.t(),
          symbol: module,
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
