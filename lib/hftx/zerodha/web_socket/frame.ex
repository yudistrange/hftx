defmodule Hftx.Zerodha.WebSocket.Frame do
  @moduledoc """
  This module defines helper functions to decode the
  various messages received over the websocket frames from zerodha
  """
  require Logger
  alias Hftx.Data.MarketEvent
  alias Hftx.Zerodha.WebSocket.Frame.MarketEventParser

  @type heartbeat :: :heartbeat
  @type user_event :: {:user_event, term()}

  @spec parse(bitstring) ::
          heartbeat | {:market_event, [MarketEvent.t()]} | user_event | {:error, :parse_error}
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

  @spec market_event(bitstring) :: {:market_event, [MarketEvent.t()]} | {:error, :parse_error}
  defp market_event(binary_packet) do
    message_size = bit_size(binary_packet) / 8
    Logger.debug("Message size #{message_size}")

    if message_size == MarketEventParser.ltp_message_size() + MarketEventParser.num_frame_size() do
      {:market_event, MarketEventParser.parse(binary_packet)}

      case MarketEventParser.parse(binary_packet) do
        {:ok, market_events} -> {:market_event, market_events}
        {:error, :parse_error} -> {:error, :parse_error}
      end
    else
      Logger.error("Expected frame size: #{MarketEventParser.ltp_message_size()}")
      {:error, :parse_error}
    end
  end

  defmodule MarketEventParser do
    @moduledoc """
    Helper module which describes the decoding of Zerodha's binary message
    All calculations here are based on bytes

    WARNING: This module only supports `ltp` mode messages
    """
    require Logger
    alias Hftx.Data.MarketEvent

    @number_of_frame 2
    @frame_size 2
    @ltp_packet_size 8
    @equity_quote_packet_size 44
    @equity_full_packet_size 184
    @index_quote_packet_size 28
    @index_full_packet_size 32

    def num_frame_size, do: @number_of_frame
    def ltp_message_size, do: @ltp_packet_size + @frame_size
    def equity_quote_packet_size, do: @equity_quote_packet_size + @frame_size
    def equity_full_packet_size, do: @equity_full_packet_size + @frame_size
    def index_quote_packet_size, do: @index_quote_packet_size + @frame_size
    def index_full_packet_size, do: @index_full_packet_size + @frame_size

    @spec parse(binary) :: {:ok, [MarketEvent.t()]} | {:error, :parse_error}
    def parse(binary_packet) do
      try do
        num_packets = get_number_of_packets(binary_packet)

        packets =
          binary_part(
            binary_packet,
            @number_of_frame,
            byte_size(binary_packet) - @number_of_frame
          )

        {:ok, parse_binary_packets(packets, num_packets - 1)}
      rescue
        _ -> {:error, :parse_error}
      end
    end

    defp get_number_of_packets(binary_packet) do
      binary_packet
      |> binary_part(0, @number_of_frame)
      |> :binary.decode_unsigned()
    end

    @spec parse_binary_packets(binary, non_neg_integer()) :: [MarketEvent.t()]
    defp parse_binary_packets(binary_packet, num_packets) do
      frame_size = binary_packet |> binary_part(0, @frame_size) |> :binary.decode_unsigned()
      this_packet = binary_part(binary_packet, @frame_size, frame_size)

      case num_packets do
        0 ->
          [parse_packet(this_packet, frame_size)]

        _ ->
          others =
            binary_part(
              binary_packet,
              @frame_size + frame_size,
              byte_size(binary_packet) - frame_size - @frame_size
            )

          [parse_packet(this_packet, frame_size), parse_binary_packets(others, num_packets - 1)]
      end
    end

    @spec parse_packet(binary(), non_neg_integer()) :: MarketEvent.t()
    defp parse_packet(packet, @ltp_packet_size) do
      instrument_token = packet |> binary_part(0, 4) |> :binary.decode_unsigned()
      ltp = packet |> binary_part(4, 4) |> :binary.decode_unsigned()

      %MarketEvent{
        timestamp: DateTime.utc_now() |> DateTime.to_unix(),
        last_trade_price: ltp,
        instrument_token: instrument_token
      }
    end

    defp parse_packet(packet, size) do
      Logger.error(
        "Received packet with unsupported size: #{size}\nPacket: #{IO.inspect(packet)}"
      )

      raise "Received Packet with unsupported size"
    end
  end
end
