defmodule PYREx.Geographies.Jurisdiction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @derive {Phoenix.Param, key: :id}

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
    |> generate_id()
    |> validate_required([:id])
  end

  def generate_id(changeset = %Ecto.Changeset{}) do
    state = changeset.changes.statefp
    type = changeset.changes.type
    fips = changeset.changes.fips
    id = "pyr-jurisdiction/type:#{type}/country:us/state:#{state}/fips:#{fips}"
    change(changeset, id: id)
  end
end
