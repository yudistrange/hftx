defmodule Hftx.Data.MarketEvent do
  @enforce_keys [:timestamp, :last_trade_price, :symbol, :instrument_token]
  defstruct [
    :timestamp,
    :symbol,
    :last_trade_price,
    :instrument_token,
    :last_trade_volume,
    :order_book
  ]

  @type t :: %__MODULE__{
          timestamp: integer(),
          last_trade_price: non_neg_integer(),
          instrument_token: non_neg_integer(),
          last_trade_volume: non_neg_integer() | nil,
          order_book: __MODULE__.OrderBook.t() | nil
        }

  defmodule OrderBook do
    @enforce_keys [:bid, :offer]
    defstruct [:bid, :offer]

    @type t :: %__MODULE__{
            bid: [__MODULE__.OrderTuple.t()],
            offer: [__MODULE__.OrderTuple.t()]
          }

    defmodule OrderTuple do
      @enforce_keys [:volume, :price]
      defstruct [:volume, :price]

      @type t :: %__MODULE__{
              volume: non_neg_integer(),
              price: non_neg_integer()
            }
    end
  end
end
