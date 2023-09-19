defmodule Sankolista.List.Registry do
  @moduledoc "Resource registry of the list part"
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry(Sankolista.List.ListItem)
  end
end
