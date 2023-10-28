defmodule Hftx.Data.MarketEvent do
  @moduledoc false

  @type t :: Hftx.Data.EquityEvent.t() | Hftx.Data.IndexEvent.t()
end
