defmodule Hftx.Data.MarketEvent do
  @enforce_keys [:timestamp, :last_trade_price, :symbol, :instrument_token]
  defstruct [
    :timestamp,
    :symbol,
    :last_trade_price,
    :instrument_token,
    :last_trade_volume,
    :total_trade_volume,
    :average_price,
    :total_trade_calls,
    :total_buy_calls,
    :total_sell_calls,
    :open_price,
    :high_price,
    :low_price,
    :close_price,
    :order_book
  ]

  @type t :: %__MODULE__{
          timestamp: integer(),
          symbol: String.t(),
          last_trade_price: Float,
          instrument_token: non_neg_integer(),
          last_trade_volume: non_neg_integer() | nil,
          average_price: Float | nil,
          total_trade_calls: non_neg_integer() | nil,
          total_buy_calls: non_neg_integer() | nil,
          total_sell_calls: non_neg_integer() | nil,
          open_price: Float | nil,
          high_price: Float | nil,
          low_price: Float | nil,
          close_price: Float | nil,
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
