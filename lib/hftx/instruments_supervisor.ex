defmodule Hftx.InstrumentsSupervisor do
  @moduledoc """

  """
  use Supervisor

  alias Hftx.Workers.Supervisor, as: WorkerSupervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Supervisor.init(generate_child_spec(), strategy: :one_for_one)
  end

  defp generate_child_spec() do
    instruments =
      Application.get_env(:hftx, :instruments) ||
        []

    instruments
    |> Enum.map(fn {instrument, _} ->
      instrument_name = instrument |> Atom.to_string()

      %{
        id: "WorkerSupervisor." <> instrument_name,
        start: {WorkerSupervisor, :start_link, [instrument_name]}
      }
    end)
  end
end
