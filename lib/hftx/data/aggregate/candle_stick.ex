defmodule Hftx.Data.Aggregate.CandleStick do 
  @enforce_keys [:open :close :high :low]
  defstruct [:open :close :high :low]
end
