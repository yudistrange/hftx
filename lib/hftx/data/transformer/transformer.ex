defmodule Hftx.Data.Transformer do 
@moduledoc """
Describes the behaviour for various data compression strategies.
Compression strategies are used to aggregate the Market Price data into compact form.
"""

# TODO: Fix the update behaviour
@callback update() : :ok
end
