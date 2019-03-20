# Since configuration is shared in umbrella projects, this file
# should only configure the :pyr_ex_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :pyr_ex_web,
  namespace: PYRExWeb,
  ecto_repos: [PYREx.Repo],
  generators: [context_app: :pyr_ex]

# Configures the endpoint
config :pyr_ex_web, PYRExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z95ZgF6eoFaWgTlrsTapqLi5x5d8uPhd3hggd+U6uMYxwXDCB0H5iWsZTnPfd9Ae",
  render_errors: [view: PYRExWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PYRExWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
