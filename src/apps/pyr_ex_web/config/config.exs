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
  secret_key_base: "3On2tzJT/0tZrcqv1Cj6jAtL6DHReXh7h+9oSIZL1FaqxHDNqx4X1UfoL5hdjzYf",
  render_errors: [view: PYRExWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PYRExWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
