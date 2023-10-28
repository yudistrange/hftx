defmodule Hftx.Zerodha.WebSocket.FrameParser.EquityFull do
  @moduledoc """
  Handles parsing equity message of type `Full`
  """
  require Logger
  alias Hftx.Data.EquityEvent

  @size 184
  def size(), do: @size

  @spec parse(binary) :: {:ok, EquityEvent.t()} | {:error, :parse_error}
  def parse(
        <<instrument_token::32, ltp::32, last_trade_volume::32, average_price::32,
          total_trade_volume::32, total_buy::32, total_sell::32, open_price::32, high_price::32,
          low_price::32, close_price::32, last_trade_timestamp::32, open_interest::32,
          open_interest_day_high::32, open_interest_day_low::32, exchange_timestamp::32,
          market_depth::binary>>
      ) do
    Logger.error(~c"Market Depth Binary size #{byte_size(market_depth)}")
    order_book = parse_market_depth(market_depth)

    {:ok,
     %EquityEvent{
       timestamp: DateTime.utc_now(),
       # TODO: Fetch symbol from the instruments table
       symbol: "",
       instrument_token: instrument_token,
       last_trade_price: ltp,
       last_trade_volume: last_trade_volume,
       average_price: average_price,
       total_trade_volume: total_trade_volume,
       total_buy_calls: total_buy,
       total_sell_calls: total_sell,
       open_price: open_price,
       high_price: high_price,
       low_price: low_price,
       close_price: close_price,
       last_trade_timestamp: last_trade_timestamp,
       open_interest: open_interest,
       open_interest_day_high: open_interest_day_high,
       open_interest_day_low: open_interest_day_low,
       exchange_timestamp: exchange_timestamp,
       order_book: order_book
     }}
  end

  def parse(_msg) do
    Logger.error("Equity Full message parsing is not implemented")
    {:error, :parse_error}
  end

  @spec parse_market_depth(bitstring()) :: EquityEvent.OrderBook.t() | nil
  defp parse_market_depth(market_depth) do
    entries =
      for <<(<<quantity::32, price::32, orders::16, _padding::16>> <- market_depth)>> do
        %EquityEvent.OrderBook.OrderTuple{quantity: quantity, price: price, orders: orders}
      end

    {bids, offers} = Enum.split(entries, 5)

    %EquityEvent.OrderBook{bid: bids, offer: offers}
  end
end
