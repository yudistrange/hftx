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

  @spec init(String.t()) :: :ok | :error
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

  @spec status() ::
          {:ok, :not_initialized}
          | {:ok, :running}
          | {:error, :invalid_token}
          | {:error, :unexpected_state}
  def status() do
    %{specs: spec, active: active, supervisors: _supervisors, workers: workers} =
      DynamicSupervisor.count_children(ZerodhaSupervisor)

    case {spec, active, workers} do
      {0, 0, 0} ->
        {:ok, :not_initialized}

      {1, 1, 1} ->
        {:error, :invalid_token}

      {2, 2, 2} ->
        {:ok, :running}

      otherwise ->
        Logger.error("Zerodha Supervisor has unexpected children: #{inspect(otherwise)}")
        {:error, :unexpected_state}
    end
  end
end
