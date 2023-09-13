defmodule Sankolista.Repo do
  use AshPostgres.Repo,
    otp_app: :sankolista

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
