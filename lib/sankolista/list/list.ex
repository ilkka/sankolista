defmodule Sankolista.List do
  @moduledoc """
  List API
  """
  use Ash.Api

  resources do
    registry(Sankolista.List.Registry)
  end
end
