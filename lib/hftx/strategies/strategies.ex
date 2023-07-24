defmodule Hftx.Strategies do
  @moduledoc """
  This module contains the various strategies used in the Hftx system

  data_transformer -> Strategies to collate market event data stream into aggregate data structure
  trader -> Strategies for trader workers to evaluate a stream of aggregates and suggest a response
  decision_maker -> Strategies for decision_maker to process the responses from various traders and take a call
  """
end
