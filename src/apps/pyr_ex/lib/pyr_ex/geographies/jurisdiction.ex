defmodule PYREx.Geographies.Jurisdiction do
  use PYREx.Schema
  import Ecto.Changeset

  schema "jurisdictions" do
    field :fips, :string
    field :geoid, :string
    field :name, :string
    field :statefp, :string
    field :type, :string
    has_one :shape,
      PYREx.Geographies.Shape,
      references: :geoid,
      foreign_key: :geoid

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
    state = Map.get(changeset.changes, :statefp, changeset.data.statefp)
    type = Map.get(changeset.changes, :type, changeset.data.type)
    fips = Map.get(changeset.changes, :fips, changeset.data.fips)
    geoid = Map.get(changeset.changes, :geoid, changeset.data.geoid)
    id = "pyr-jurisdiction/type:#{type}/country:us/geoid:#{geoid}/state:#{state}/fips:#{fips}"
    change(changeset, id: id)
  end
end
