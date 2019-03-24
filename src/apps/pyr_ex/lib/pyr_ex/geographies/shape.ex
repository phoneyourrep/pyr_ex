defmodule PYREx.Geographies.Shape do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @derive {Phoenix.Param, key: :id}

  schema "shapes" do
    field :geom, Geo.PostGIS.Geometry
    field :geoid, :string
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

  def generate_id(changeset = %Ecto.Changeset{}) do
    geoid = changeset.changes.geoid
    id = "pyr-jurisdiction/country:us/geoid:#{geoid}"
    change(changeset, id: id)
  end
end
