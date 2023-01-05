defmodule Hftx.Data.Aggregate.CandleStick do
  @enforce_keys [:open, :close, :high, :low]
  defstruct [:open, :close, :high, :low, :filled]

  @type t :: %__MODULE__{
          open: non_neg_integer(),
          close: non_neg_integer(),
          high: non_neg_integer(),
          low: non_neg_integer(),
          filled: boolean()
        }
end
