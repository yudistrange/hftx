defmodule Hftx.Zerodha.TokenStore do
  @moduledoc """
  An elixir trader that will store the access_token received from the Zerodha callback API
  """
  # TODO: Possible refactor into an ETS table
  # Agent might not be performative enough(?)
  use Agent

  # TODO: Register the trader on registry
  def start_link(access_token) do
    Agent.start_link(fn -> %{access_token: access_token} end, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, &Map.get(&1, :access_token))
  end

  def update(token) do
    Agent.update(__MODULE__, &Map.put(&1, :access_token, token))
  end
end
