defmodule PYREx.Repo.Migrations.CreateJurisdictions do
  use Ecto.Migration

  def change do
    create table(:jurisdictions, primary_key: false) do
      add :id, :string, primary_key: true
      add :type, :string
      add :name, :string
      add :geoid, :string
      add :statefp, :string
      add :fips, :string

      timestamps()
    end
  end
end
