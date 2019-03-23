defmodule PYREx.Geographies.Jurisdiction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jurisdictions" do
    field :fips, :string
    field :geoid, :string
    field :name, :string
    field :statefp, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(jurisdiction, attrs) do
    jurisdiction
    |> cast(attrs, [:type, :name, :geoid, :statefp, :fips])
    |> validate_required([:type, :name, :geoid, :statefp, :fips])
  end
end
