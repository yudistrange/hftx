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
    :last_trade_timestamp,
    :open_interest,
    :open_interest_day_high,
    :open_interest_day_low,
    :exchange_timestamp,
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
          last_trade_timestamp: non_neg_integer() | nil,
          open_interest: non_neg_integer() | nil,
          open_interest_day_high: non_neg_integer() | nil,
          open_interest_day_low: non_neg_integer() | nil,
          exchange_timestamp: non_neg_integer() | nil,
          order_book: __MODULE__.OrderBook.t() | nil
        }

  defmodule OrderBook do
    @moduledoc false

    @enforce_keys [:bid, :offer]
    defstruct [:bid, :offer]

    @typedoc """
    OrderBook struct defines the structure of an order book

    ## Fields
      * `:bid` - List of current top bids 
      * `:offer` - List of current top offers
    """

    @type t :: %__MODULE__{
            bid: [__MODULE__.OrderTuple.t()],
            offer: [__MODULE__.OrderTuple.t()]
          }

    defmodule OrderTuple do
      @moduledoc false

      @enforce_keys [:quantity, :orders, :price]
      defstruct [:quantity, :orders, :price]

      @typedoc """
      OrderTuple struct defines the structure of individual entries in an order book

      ## Fields
        * `:quantity` - The total quantity of stocks under bid / offer
        * `:price` - The price for the bid / offer.
        * `:orders` - Total number of orders that are operating at this price.
      """
      @type t :: %__MODULE__{
              quantity: non_neg_integer(),
              price: non_neg_integer(),
              orders: non_neg_integer()
            }
    end
  end
end
