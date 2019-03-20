# Since configuration is shared in umbrella projects, this file
# should only configure the :pyr_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :pyr_ex, PYREx.Repo,
  username: "postgres",
  password: "postgres",
  database: "pyr_ex_dev",
  hostname: "db",
  pool_size: 10,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]
