defmodule PYREx.Geographies.Jurisdiction do
  use PYREx.Schema
  import Ecto.Changeset
  alias PYREx.Geographies.{Jurisdiction, Shape}

  schema "jurisdictions" do
    field :fips, :string
    field :geoid, :string
    field :name, :string
    field :type, :string

    belongs_to :state,
               Jurisdiction,
               references: :fips,
               foreign_key: :statefp,
               where: [type: "us_state"]

    has_many :divisions,
             Jurisdiction,
             references: :fips,
             foreign_key: :statefp,
             where: [type: {:in, ["us_cd"]}]

    has_one :shape,
            Shape,
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

  @doc false
  def generate_id(changeset = %Ecto.Changeset{}) do
    state = Map.get(changeset.changes, :statefp, changeset.data.statefp)
    type = Map.get(changeset.changes, :type, changeset.data.type)
    fips = Map.get(changeset.changes, :fips, changeset.data.fips)
    geoid = Map.get(changeset.changes, :geoid, changeset.data.geoid)
    id = "pyr-jurisdiction/type:#{type}/country:us/geoid:#{geoid}/state:#{state}/fips:#{fips}"
    change(changeset, id: id)
  end
end
