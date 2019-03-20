defmodule PYREx.Repo do
  use Ecto.Repo,
    otp_app: :pyr_ex,
    adapter: Ecto.Adapters.Postgres

  Postgrex.Types.define(PYREx.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Poison)
end
