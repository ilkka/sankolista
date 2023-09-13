defmodule Sankolista.List do
  use Ash.Api

  resources do
    registry Sankolista.List.Registry
  end
end
