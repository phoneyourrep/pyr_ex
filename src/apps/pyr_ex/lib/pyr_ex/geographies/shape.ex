defmodule PYREx.Geographies.Shape do
  use Ecto.Schema
  import Ecto.Changeset

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
  end
end
