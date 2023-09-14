defmodule Sankolista.Accounts do
  use Ash.Api

  resources do
    resource Sankolista.Accounts.User
  end
end
