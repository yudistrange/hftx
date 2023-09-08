defmodule Hftx.Zerodha.WebSocket do
  @moduledoc """
  Describes the websocket connection to zerodha
  """
  use WebSockex
  require Logger

  alias Hftx.Zerodha.WebSocket.Frame

  def start_link(access_token) do
    ws_url = url(access_token)
    WebSockex.start_link(ws_url, __MODULE__, %{})
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

  def handle_frame({:binary, msg}, state) do
    Logger.debug("Received a binary msg: #{inspect(msg, limit: :infinity)}")
    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    Logger.debug("Received a text msg: #{inspect(msg, limit: :infinity)}")
    {:ok, state}
  end

  def handle_frame({type, msg}, state) do
    Logger.warning("Received a message of unknown type: #{inspect(type)}\nMessage: #{msg}")

    case Frame.parse(msg) do
      :heartbeat -> nil
      {:user_event, _msg} -> nil
      {:market_event, _event} -> nil
      {:error, :parse_error} -> nil
    end

    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    Logger.debug("Sending Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
    {:reply, frame, state}
  end

  def handle_disconnect(connection_status_map, state) do
    Logger.warning("Websocket disconnect with reason: #{Map.get(connection_status_map, :reason)}")
    {:ok, state |> Map.put(:status, :disconnected)}
  end

  def terminate(close_reason, _state) do
    Logger.info("Websocket terminating with reason #{close_reason}")
  end
end
