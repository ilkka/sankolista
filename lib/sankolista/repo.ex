defmodule Sankolista.Repo do
  use Ecto.Repo,
    otp_app: :sankolista,
    adapter: Ecto.Adapters.Postgres
end
