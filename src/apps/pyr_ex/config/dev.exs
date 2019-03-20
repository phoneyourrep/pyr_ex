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
  hostname: System.get_env("DOCKER_PYR_PG_HOST") || "localhost",
  pool_size: 10,
  extensions: [{Geo.PostGIS.Extension, library: Geo}],
  adapter: Ecto.Adapters.Postgres,
  types: MyApp.PostgresTypes
