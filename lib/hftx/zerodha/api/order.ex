defmodule Hftx.Zerodha.Api.Order do
  alias Hftx.Zerodha.Api.Utils
  @url "http://localhost:3000"
  @api_key "blah"
  @api_secret "secret"

  @type tradingsymbol :: String.t()
  @type exchange :: NSE | BSE
  @type transaction_type :: BUY | SELL
  @type order_type :: MARKET | LIMIT | SL
  @type quantity :: integer
  @type product :: CNC | NRML | MIS
  @type price :: float

  @spec create(
          String.t(),
          tradingsymbol,
          exchange,
          transaction_type,
          order_type,
          quantity,
          product,
          price
        ) ::
          {:ok, any} | {:error, any}
  def create(
        access_token,
        tradingsymbol,
        exchange,
        transaction_type,
        order_type,
        quantity,
        product,
        price
      ) do
    HTTPoison.post(
      @url <> "/orders/regular",
      %{
        tradingsymbol: tradingsymbol,
        exchange: exchange,
        transaction_type: transaction_type,
        order_type: order_type,
        quantity: quantity,
        product: product,
        price: price
      },
      Utils.authorization_headers(@api_key, access_token)
    )
  end

  @spec get(String.t()) :: {:ok, any} | {:error, any}
  def get(access_token) do
    HTTPoison.get(
      @url <> "/orders",
      Utils.authorization_headers(@api_key, access_token)
    )
  end

  @spec completed(String.t()) :: {:ok, any} | {:error, any}
  def completed(access_token) do
    HTTPoison.get(
      @url <> "/trades",
      Utils.authorization_headers(@api_key, access_token)
    )
  end
end
