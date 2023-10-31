defmodule Hftx.Data.MarketEvent do
  @moduledoc false

  alias Hftx.Data.EquityEvent
  alias Hftx.Data.IndexEvent

  @type t :: EquityEvent.t() | IndexEvent.t()
end
