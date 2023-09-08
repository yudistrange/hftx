defmodule Hftx.Zerodha.WebSocket.Frame do
  @moduledoc """
  This module defines helper functions to decode the
  various messages received over the websocket frames from zerodha
  """
  require Logger
  alias Hftx.Data.MarketEvent
  alias Hftx.Zerodha.WebSocket.FrameParser

  @type heartbeat :: :heartbeat
  @type user_event :: {:user_event, term()}
  @type market_event :: {:market_event, [MarketEvent.t()]}

  @number_messages_bits 16
  @message_size_bits 16

  @spec parse(bitstring) :: heartbeat | market_event | user_event | {:error, :parse_error}
  def parse(frame) do
    {json_parse_status, json_parse_result} = Jason.decode(frame)

    cond do
      byte_size(frame) == 1 -> heartbeat_message()
      :ok == json_parse_status -> user_event(json_parse_result)
      true -> market_event(frame)
    end
  end

  @spec heartbeat_message() :: heartbeat
  defp heartbeat_message() do
    :heartbeat
  end

  @spec user_event(bitstring) :: user_event
  defp user_event(parsed_json_frame) do
    {:user_event, parsed_json_frame}
  end

  @spec market_event(binary) :: market_event | {:error, :parse_error}
  def market_event(<<num_msgs::@number_messages_bits, frame::binary>>) when is_binary(frame) do
    {:market_event, recursive_market_event_parse(num_msgs, frame)}
  end

  def market_event(frame) when is_bitstring(frame) do
    Logger.error("Expected frame size: #{inspect(frame)}")
    {:error, :parse_error}
  end

  @spec recursive_market_event_parse(integer, binary, [MarketEvent.t()]) :: [MarketEvent.t()]
  defp recursive_market_event_parse(num_messages, binary_messages),
    do: recursive_market_event_parse(num_messages, binary_messages, [])

  defp recursive_market_event_parse(0, _, market_events),
    do: market_events

  defp recursive_market_event_parse(
         num_messages,
         <<first_msg_length::@message_size_bits, messages::binary>> = frame,
         market_events
       ) do
    first_msg = Kernel.binary_part(frame, 0, div(@message_size_bits, 8) + first_msg_length)

    rest =
      Kernel.binary_part(
        messages,
        first_msg_length,
        Kernel.byte_size(messages) - first_msg_length
      )

    case FrameParser.parse(first_msg) do
      {:ok, market_event} ->
        recursive_market_event_parse(num_messages - 1, rest, [
          market_event | market_events
        ])

      {:error, :parse_error} ->
        recursive_market_event_parse(num_messages - 1, rest, market_events)
    end
  end
end
