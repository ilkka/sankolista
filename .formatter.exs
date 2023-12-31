[
  import_deps: [
    :ecto,
    :phoenix,
    :ash,
    :ash_phoenix,
    :ash_postgres,
    :ash_authentication,
    :ash_authentication_postgres
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
