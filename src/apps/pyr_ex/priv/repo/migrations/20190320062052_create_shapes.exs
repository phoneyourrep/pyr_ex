defmodule PYREx.Repo.Migrations.CreateShapes do
  use Ecto.Migration

  def change do
    create table(:shapes, primary_key: false) do
      add :id, :string, primary_key: true
      add :geoid, :string
      add :geom, :geometry

      timestamps()
    end
  end
end
