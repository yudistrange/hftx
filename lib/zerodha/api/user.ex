defmodule Hftx.Zerodha.Api.User do
  @url "http://localhost:3000"
  @api_key "blah"
  @api_secret "secret"

  def login() do
    HTTPoison.get(@url <> "/connect/login?v=3&api_key=" <> @api_key)
  end

  @spec checksum(String.t()) :: String.t()
  defp checksum(access_token) do
    # TODO: SHA256 hash of the following
    @api_key <> access_token <> @api_secret
  end

  @spec authorization_header(String.t()) :: String.t()
  defp authorization_header(access_token) do
    "token " <> @api_key <> ":" <> access_token
  end

  def create_token(access_token) do
    HTTPoison.post(
      @url <> "/session/token",
      %{api_key: @api_key, access_token: access_token, checksum: checksum(access_token)},
      [{"Content-Type", "application/json"}, {"X-Kite-Version", "3"}]
    )
  end

  def profile(access_token) do
    HTTPoison.get(
      @url <> "/user/profile",
      [
        {"Content-Type", "application/json"},
        {"X-Kite-Version", "3"},
        {"Authorization", authorization_header(access_token)}
      ]
    )
  end

  def margin(access_token) do
    HTTPoison.get(
      @url <> "/user/margins",
      [
        {"Content-Type", "application/json"},
        {"X-Kite-Version", "3"},
        {"Authorization", authorization_header(access_token)}
      ]
    )
  end

  def logout(access_token) do
    HTTPoison.delete(
      @url <> "/session/token?api_key=" <> @api_key <> "?access_token=" <> access_token
    )
  end
end
