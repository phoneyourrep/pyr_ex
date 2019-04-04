# Since configuration is shared in umbrella projects, this file
# should only configure the :pyr_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :pyr_ex,
  namespace: PYREx,
  ecto_repos: [PYREx.Repo]

# # General application configuration
# config :pyr_ex_web,
#   namespace: PYRExWeb,
#   ecto_repos: [PYREx.Repo],
#   generators: [context_app: :pyr_ex]

# Configures the endpoint
config :pyr_ex, PYRExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z95ZgF6eoFaWgTlrsTapqLi5x5d8uPhd3hggd+U6uMYxwXDCB0H5iWsZTnPfd9Ae",
  render_errors: [view: PYRExWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PYREx.PubSub, adapter: Phoenix.PubSub.PG2]

config :pyr_ex, PYRExWeb.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: {:system, "PYREX_SENDGRID_API_KEY"}

# Use Jason for JSON parsing in Phoenix and all sub apps
config :phoenix, :json_library, Jason
config :geo_postgis, json_library: Jason
config :postgrex, :json_library, Jason
config :bamboo, :json_library, Jason

import_config "#{Mix.env()}.exs"
