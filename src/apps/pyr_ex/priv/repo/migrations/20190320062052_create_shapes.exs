defmodule PYREx.Repo.Migrations.CreateShapes do
  use Ecto.Migration

  def change do
    create table(:shapes) do
      add :geoid, :string
      add :geom, :geometry

      timestamps()
    end
  end
end
