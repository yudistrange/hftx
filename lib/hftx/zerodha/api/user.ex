defmodule Hftx.Zerodha.Api.User do
  alias Hftx.Zerodha.Api.Utils

  @url "http://localhost:3000"
  @api_key "blah"
  @api_secret "secret"

  def login() do
    HTTPoison.get(@url <> "/connect/login?v=3&api_key=" <> @api_key)
  end

  @spec create_token(String.t()) :: {:ok, any} | {:error, any}
  def create_token(access_token) do
    HTTPoison.post(
      @url <> "/session/token",
      %{
        api_key: @api_key,
        access_token: access_token,
        checksum: Utils.checksum(@api_key, @api_secret, access_token)
      },
      Utils.common_headers()
    )
  end

  @spec profile(String.t()) :: {:ok, any} | {:error, any}
  def profile(access_token) do
    HTTPoison.get(
      @url <> "/user/profile",
      Utils.authorization_headers(@api_key, access_token)
    )
  end

  @spec margin(String.t()) :: {:ok, any} | {:error, any}
  def margin(access_token) do
    HTTPoison.get(
      @url <> "/user/margins",
      Utils.authorization_headers(@api_key, access_token)
    )
  end

  @spec logout(String.t()) :: {:ok, any} | {:error, any}
  def logout(access_token) do
    HTTPoison.delete(
      @url <> "/session/token?api_key=" <> @api_key <> "?access_token=" <> access_token
    )
  end

  @spec positions(String.t()) :: {:ok, any} | {:error, any}
  def positions(access_token) do
    HTTPoison.get(
      @url <> "/portfolio/positions",
      Utils.authorization_headers(@api_key, access_token)
    )
  end
end
