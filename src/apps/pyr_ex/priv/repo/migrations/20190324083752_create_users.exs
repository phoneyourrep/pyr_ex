defmodule PYREx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :website, :string
      add :organization, :string
      add :intended_usage, :text

      timestamps()
    end
  end
end
