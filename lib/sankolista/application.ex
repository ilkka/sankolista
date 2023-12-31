defmodule Sankolista.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SankolistaWeb.Telemetry,
      # Start the Ash repository
      Sankolista.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sankolista.PubSub},
      # Start Finch
      {Finch, name: Sankolista.Finch},
      # Start the Endpoint (http/https)
      SankolistaWeb.Endpoint,
      # Authentication supervisor
      {AshAuthentication.Supervisor, otp_app: :sankolista}
      # Start a worker by calling: Sankolista.Worker.start_link(arg)
      # {Sankolista.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sankolista.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SankolistaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
