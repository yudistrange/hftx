defmodule Hftx.Zerodha.WebSocket do
  @moduledoc """
  Describes the websocket connection to zerodha
  """
  use WebSockex
  require Logger

  def start_link(url) do
    WebSockex.start_link(url, __MODULE__, %{})
  end

  def url(access_token) do
    zerodha_config = Application.get_env(:hftx, :zerodha)
    api_key = zerodha_config[:api_key]
    web_socket_url = zerodha_config[:web_socket_url]
    web_socket_url <> "?api_key=" <> api_key <> "&access_token=" <> access_token
  end

  def handle_connect(_conn, state) do
    Logger.info("Websocket connection established!")
    {:ok, state |> Map.put(:status, :connected)}
  end

  def handle_frame({type, msg}, state) do
    Logger.debug("Received Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
    {:ok, state}
  end

  def handle_disconnect(connection_status_map, state) do
    Logger.warn("Websocket disconnect with reason: #{Map.get(connection_status_map, :reason)}")
    {:ok, state |> Map.put(:status, :disconnected)}
  end

  def terminate(close_reason, _state) do
    Logger.info("Websocket terminating with reason #{close_reason}")
  end
end
