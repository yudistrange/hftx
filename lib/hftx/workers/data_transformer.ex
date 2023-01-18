defmodule Hftx.Workers.DataTransformer do
  @moduledoc """
  Worker process that performs data aggregation using the strategies in [DataTransformer](hftx/lib/hftx/strategies/data_transfomer/data_transformer.ex)
  """
  @behaviour GenServer

  @spec name({module, String.t()}) :: String.t()
  def name({aggregation_strategy, instrument_id}) do
    "DataTransformer-" <> (aggregation_strategy |> Atom.to_string()) <> "-" <> instrument_id
  end

  @spec start_link({non_neg_integer(), module, String.t()}) ::
          :ignore | {:error, any} | {:ok, pid}
  def start_link({aggregation_window, aggregation_strategy, instrument_id}) do
    GenServer.start_link(__MODULE__, {aggregation_window, aggregation_strategy, instrument_id})
  end

  @impl true
  def init({aggregation_window, aggregation_strategy, instrument_id}) do
    {:ok,
     %{
       aggregation_window: aggregation_window,
       market_events: [],
       aggregation_strategy: aggregation_strategy,
       instrument_id: instrument_id
     }}
  end

  @impl true
  def handle_cast(
        {:observe, market_event},
        %{
          market_events: market_events,
          aggregation_window: aggregation_window,
          aggregation_strategy: aggregation_strategy,
          instrument_id: instrument_id
        } = state
      ) do
    if Enum.count(market_events) + 1 >= aggregation_window do
      aggregate({aggregation_strategy, :transform, [market_event | market_events]}, instrument_id)
      {:noreply, state |> Map.put(:market_events, [])}
    else
      {:noreply, state |> Map.put(:market_events, [market_event | market_events])}
    end
  end

  defp aggregate({module, func, args}, _instrument_id) do
    agg = apply(module, func, args)

    # TODO:
    # - Dispatch the aggregate to workers based on instrument_id

    agg
  end
end
