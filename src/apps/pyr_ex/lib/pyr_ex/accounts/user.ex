defmodule PYREx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :intended_usage, :string
    field :name, :string
    field :organization, :string
    field :website, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :website, :organization, :intended_usage])
    |> validate_required([:email, :name, :website, :organization, :intended_usage])
  end
end
