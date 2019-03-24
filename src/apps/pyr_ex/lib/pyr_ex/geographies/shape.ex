defmodule PYREx.Geographies.Shape do
  use PYREx.Schema
  import Ecto.Changeset

  schema "shapes" do
    field :geom, Geo.PostGIS.Geometry

    belongs_to :jurisdiction,
               PYREx.Geographies.Jurisdiction,
               references: :geoid,
               foreign_key: :geoid

    timestamps()
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:geoid, :geom])
    |> validate_required([:geom, :geoid])
    |> generate_id()
    |> validate_required([:id])
  end

  @doc false
  def generate_id(changeset = %Ecto.Changeset{}) do
    geoid = Map.get(changeset.changes, :geoid, changeset.data.geoid)
    id = "pyr-jurisdiction/country:us/geoid:#{geoid}"
    change(changeset, id: id)
  end
end
