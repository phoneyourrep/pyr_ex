# Since configuration is shared in umbrella projects, this file
# should only configure the :pyr_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :pyr_ex,
  namespace: PYREx,
  ecto_repos: [PYREx.Repo]

import_config "#{Mix.env()}.exs"
