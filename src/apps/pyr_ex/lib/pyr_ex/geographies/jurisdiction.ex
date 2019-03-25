defmodule PYREx.Geographies.Jurisdiction do
  use PYREx.Schema
  import Ecto.Changeset
  alias PYREx.Geographies.{Jurisdiction, Shape}

  schema "jurisdictions" do
    field :geoid, :string
    field :name, :string
    field :type, :string
    field :mtfcc, :string
    field :pyrgeoid, :string

    belongs_to :state,
               Jurisdiction,
               references: :statefp,
               foreign_key: :statefp,
               where: [type: "us_state"]

    has_many :divisions,
             Jurisdiction,
             references: :statefp,
             foreign_key: :statefp,
             where: [type: {:in, ["us_cd", "us_sldl", "us_sldu"]}]

    has_one :shape,
            Shape,
            references: :pyrgeoid,
            foreign_key: :pyrgeoid

    timestamps()
  end

  @doc false
  def changeset(jurisdiction, attrs) do
    jurisdiction
    |> cast(attrs, [:type, :name, :geoid, :statefp, :mtfcc])
    |> validate_required([:type, :name, :geoid, :statefp, :mtfcc])
    |> generate_pyrgeoid()
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
    statefp = Map.get(changeset.changes, :statefp, changeset.data.statefp)
    type = Map.get(changeset.changes, :type, changeset.data.type)
    pyrgeoid = Map.get(changeset.changes, :pyrgeoid, changeset.data.pyrgeoid)
    id = "pyr-jurisdiction/type:#{type}/country:us/pyrgeoid:#{pyrgeoid}/statefp:#{statefp}"
    change(changeset, id: id)
  end
end
