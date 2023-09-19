import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

values = Vapor.load!([
  %Vapor.Provider.Dotenv{overwrite: true},
  %Vapor.Provider.Env{
    bindings: [
      {:phx_server, "PHX_SERVER", default: false, map: fn s -> s in ~w(true 1) end},
      {:hostname, "PHX_HOST", default: "localhost"},
      {:port, "PORT", default: 4000, map: &String.to_integer/1},
      {:url_scheme, "URL_SCHEME", default: "http"},
      {:secret_key_base, "SECRET_KEY_BASE"},
      {:auth0_client_id, "AUTH0_CLIENT_ID"},
      {:auth0_client_secret, "AUTH0_CLIENT_SECRET"},
      {:database_url, "DATABASE_URL"},
      {:pool_size, "POOL_SIZE", default: 10, map: &String.to_integer/1},
      {:ecto_ipv6, "ECTO_IPV6", default: false, map: fn s -> s in ~w(true 1) end}
    ]
  }
])

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/sankolista start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if values.phx_server do
  config :sankolista, SankolistaWeb.Endpoint, server: true
end

config :sankolista, :auth0,
  client_id: values.client_id,
  client_secret: values.client_secret

config :sankolista, Sankolista.Repo,
  url: values.database_url,
  pool_size: values.pool_size

if config_env() == :prod do
  maybe_ipv6 = if values.ecto_ipv6, do: [:inet6], else: []

  config :sankolista, Sankolista.Repo,
    # ssl: true,
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  config :sankolista, SankolistaWeb.Endpoint,
    url: [host: values.hostname, port: values.port, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :sankolista, SankolistaWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your endpoint, ensuring
  # no data is ever sent via http, always redirecting to https:
  #
  #     config :sankolista, SankolistaWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :sankolista, Sankolista.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
