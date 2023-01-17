defmodule Hftx.Zerodha.TokenStore do
  @moduledoc """
  An elixir agent that will store the access_token received from the Zerodha callback API
  """
  use Agent

  # TODO: Register the agent on registry
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