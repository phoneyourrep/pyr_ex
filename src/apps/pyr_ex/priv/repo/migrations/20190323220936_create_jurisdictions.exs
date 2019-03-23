defmodule PYREx.Repo.Migrations.CreateJurisdictions do
  use Ecto.Migration

  def change do
    create table(:jurisdictions) do
      add :type, :string
      add :name, :string
      add :geoid, :string
      add :statefp, :string
      add :fips, :string

      timestamps()
    end

  end
end
