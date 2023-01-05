defmodule Hftx.Data.Market.Event do
  @ensure_keys [:timestamp, :last_trade_price, :last_trade_volume]
  defstruct [:timestamp, :last_trade_price, :last_trade_volume, :order_book]

  @type t :: %__MODULE__{
          timestamp: DateTime.t(),
          last_trade_price: non_neg_integer(),
          last_trade_volume: non_neg_integer(),
          order_book: OrderBook.t()
        }

  defmodule OrderBook do
    @ensure_keys [:bid, :offer]
    defstruct [:bid, :offer]

    @type t :: %__MODULE__{
            bid: [OrderTuple.t()],
            offer: [OrderTuple.t()]
          }

    defmodule OrderTuple do
      @ensure_keys [:volume, :price]
      defstruct [:volume, :price]

      @type t :: %__MODULE__{
              volume: non_neg_integer(),
              price: non_neg_integer()
            }
    end
  end
end
