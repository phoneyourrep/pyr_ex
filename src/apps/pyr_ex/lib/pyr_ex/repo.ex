defmodule PYREx.Repo do
  use Ecto.Repo,
    otp_app: :pyr_ex,
    adapter: Ecto.Adapters.Postgres
end
