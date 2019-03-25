defmodule PYREx.Geographies.Shape do
  use PYREx.Schema
  import Ecto.Changeset

  schema "shapes" do
    field :geom, Geo.PostGIS.Geometry
    field :mtfcc, :string
    field :geoid, :string

    belongs_to :jurisdiction,
               PYREx.Geographies.Jurisdiction,
               references: :pyrgeoid,
               foreign_key: :pyrgeoid

    timestamps()
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:geoid, :geom, :mtfcc])
    |> validate_required([:geom, :geoid, :mtfcc])
    |> generate_pyrgeoid
    |> generate_id()
    |> validate_required([:id, :pyrgeoid])
  end

  @doc false
  def generate_pyrgeoid(changeset = %Ecto.Changeset{}) do
    geoid = Map.get(changeset.changes, :geoid, changeset.data.geoid)
    mtfcc = Map.get(changeset.changes, :mtfcc, changeset.data.mtfcc)
    change(changeset, pyrgeoid: "#{mtfcc}#{geoid}")
  end

  @doc false
  def generate_id(changeset = %Ecto.Changeset{}) do
    pyrgeoid = Map.get(changeset.changes, :pyrgeoid, changeset.data.pyrgeoid)
    id = "pyr-shape/country:us/pyrgeoid:#{pyrgeoid}"
    change(changeset, id: id)
  end
end
