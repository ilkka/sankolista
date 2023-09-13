defmodule Sankolista.List.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Sankolista.List.ListItem
  end
end
