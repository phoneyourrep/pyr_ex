defmodule PYREx.Repo.Migrations.CreateShapes do
  use Ecto.Migration

  def change do
    create table(:shapes) do
      add :statefp, :string
      add :cd115fp, :string
      add :affgeoid, :string
      add :geoid, :string
      add :lsad, :string
      add :cdsessn, :string
      add :geom, :geometry

      timestamps()
    end
  end
end
