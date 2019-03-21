defmodule PYREx.Districts.Shape do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shapes" do
    field :geom, Geo.PostGIS.Geometry
    field :statefp, :string
    field :cd115fp, :string
    field :affgeoid, :string
    field :geoid, :string
    field :lsad, :string
    field :cdsessn, :string
    timestamps()
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:statefp, :cd115fp, :affgeoid, :geoid, :lsad, :cdsessn, :geom])
    |> validate_required([:geom])
  end
end
