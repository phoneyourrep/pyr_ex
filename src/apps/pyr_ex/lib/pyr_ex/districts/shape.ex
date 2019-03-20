defmodule PYREx.Districts.Shape do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shapes" do
    field :geom, Geo.PostGIS.Geometry
    field :identifier, :string

    timestamps()
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:identifier, :geom])
    |> validate_required([:identifier, :geom])
  end
end
