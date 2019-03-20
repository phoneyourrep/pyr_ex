defmodule PYREx.Repo.Migrations.CreateShapesTable do
  use Ecto.Migration

  def change do
    create table(:shapes) do
      add :identifier, :string
      add :geom, :geometry
    end
  end
end
