defmodule Sankolista.Secrets do
  @moduledoc """
  Secrets for Ash.
  """
  use AshAuthentication.Secret

  @impl AshAuthentication.Secret
  def secret_for([:authentication, :strategies, :auth0, :client_id], Sankolista.Accounts.User, _) do
    get_config(:client_id)
  end

  @impl AshAuthentication.Secret
  def secret_for(
        [:authentication, :strategies, :auth0, :client_secret],
        Sankolista.Accounts.User,
        _
      ) do
    get_config(:client_secret)
  end

  @impl AshAuthentication.Secret
  def secret_for(
        [:authentication, :strategies, :auth0, :redirect_uri],
        Sankolista.Accounts.User,
        _
      ) do
    get_config(:redirect_uri)
  end

  @impl AshAuthentication.Secret
  def secret_for([:authentication, :strategies, :auth0, :site], Sankolista.Accounts.User, _) do
    get_config(:site)
  end

  defp get_config(key) do
    :sankolista
    |> Application.get_env(:auth0, [])
    |> Keyword.fetch(key)
  end
end
