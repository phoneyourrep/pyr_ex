# Since configuration is shared in umbrella projects, this file
# should only configure the :pyr_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :pyr_ex, PYREx.Repo,
  username: "postgres",
  password: "postgres",
  database: "pyr_ex_test",
  hostname: System.get_env("DOCKER_PYR_PG_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  extensions: [{Geo.PostGIS.Extension, library: Geo}],
  adapter: Ecto.Adapters.Postgres,
  types: PYREx.PostgresTypes
