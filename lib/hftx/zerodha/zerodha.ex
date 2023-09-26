defmodule Hftx.Zerodha do
  @moduledoc """
  Zerodha kite API client implementation.
  """
  require Logger
  alias Hftx.Zerodha.Supervisor, as: ZerodhaSupervisor
  alias Hftx.Zerodha.TokenStore
  alias Hftx.Zerodha.WebSocket

  defp start_token_store(access_token) do
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

  defp start_websocket(access_token) do
    websocket_url = WebSocket.url(access_token)
    spec = %{id: WebSocket, start: {WebSocket, :start_link, [websocket_url]}}
    DynamicSupervisor.start_child(ZerodhaSupervisor, spec)
  end

  def init(access_token) do
    with {:ok, _token_store} <- start_token_store(access_token),
         {:ok, _websocket} <- start_websocket(access_token) do
      :ok
    else
      err ->
        Logger.error(
          "Failed to start zerodha processes on Token update with error: #{inspect(err)}"
        )

        :error
    end
  end
end
