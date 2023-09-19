defmodule Sankolista.Accounts do
  @moduledoc """
  Accounts API for authentication.
  """
  use Ash.Api

  resources do
    resource(Sankolista.Accounts.User)
  end
end
