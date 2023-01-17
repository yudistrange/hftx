defmodule Hftx.Zerodha do
  @moduledoc """
  Zerodha kite API client implementation.
  """
  alias Hftx.Zerodha.Supervisor, as: ZerodhaSupervisor
  alias Hftx.Zerodha.TokenStore
  alias Hftx.Zerodha.WebSocket

  def start_token_store(access_token) do
    spec = %{id: TokenStore, start: {TokenStore, :start_link, [access_token]}}

    case DynamicSupervisor.start_child(ZerodhaSupervisor, spec) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        # TokenStore process already active, update with the new access_token
        TokenStore.update(access_token)
        {:ok, pid}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def start_websocket(access_token) do
    websocket_url = WebSocket.url(access_token)
    spec = %{id: WebSocket, start: {WebSocket, :start_link, [websocket_url]}}
    DynamicSupervisor.start_child(ZerodhaSupervisor, spec)
  end
end
