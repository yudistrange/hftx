defmodule Hftx.Zerodha.Supervisor do
  @moduledoc """
  Supervisor process that manages `TokenStore` and `WebSocket` process
  """
  use DynamicSupervisor

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
