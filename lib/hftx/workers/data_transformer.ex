defmodule Hftx.Workers.DataTransformer do
  @moduledoc """
  Worker process that performs data aggregation using the strategies in [DataTransformer](hftx/lib/hftx/strategies/data_transfomer/data_transformer.ex)
  """
  use GenServer

  @spec name(String.t()) :: atom()
  def name(instrument_id) do
    ("DataTransformer." <> instrument_id) |> String.to_atom()
  end

  @spec start_link(String.t(), {module}) ::
          :ignore | {:error, any} | {:ok, pid}
  def start_link(instrument_id, {aggregation_strategy}) do
    GenServer.start_link(__MODULE__, {aggregation_strategy, instrument_id},
      name: name(instrument_id)
    )
  end

  @impl true
  def init({aggregation_strategy, instrument_id}) do
    {:ok,
     %{
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
          aggregation_strategy: aggregation_strategy,
          instrument_id: instrument_id
        } = state
      ) do
    aggregation_window = apply(aggregation_strategy, :aggregation_size, [])

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
