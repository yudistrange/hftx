defmodule Hftx.Data.IndexEvent do
  @moduledoc false

  @enforce_keys [
    :timestamp,
    :symbol,
    :instrument_token,
    :last_trade_price,
    :high_price,
    :low_price,
    :open_price,
    :close_price,
    :price_change
  ]

  defstruct [
    :timestamp,
    :symbol,
    :instrument_token,
    :last_trade_price,
    :high_price,
    :low_price,
    :open_price,
    :close_price,
    :price_change,
    :exchange_timestamp
  ]

  @type t :: %__MODULE__{
          timestamp: DateTime.t(),
          symbol: String.t(),
          instrument_token: integer(),
          high_price: Float | nil,
          low_price: Float | nil,
          open_price: Float | nil,
          close_price: Float | nil,
          price_change: non_neg_integer(),
          exchange_timestamp: non_neg_integer() | nil
        }
end
