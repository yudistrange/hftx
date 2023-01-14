defmodule Hftx.Zerodha.Api.Utils do
  @spec checksum(String.t(), String.t(), String.t()) :: String.t()
  def checksum(api_key, api_secret, access_token) do
    :crypto.hash(:sha256, api_key <> access_token <> api_secret) |> Base.encode16()
  end

  @spec authorization_token(String.t(), String.t()) :: String.t()
  def authorization_token(api_key, access_token) do
    "token " <> api_key <> ":" <> access_token
  end

  @spec common_headers() :: [{String.t(), String.t()}]
  def common_headers() do
    [
      {"Content-Type", "application/json"},
      {"X-Kite-Version", "3"}
    ]
  end

  @spec authorization_headers(String.t(), String.t()) :: {String.t(), String.t()}
  def authorization_headers(api_key, access_token) do
    {"Authorization", authorization_token(api_key, access_token)}
  end
end
