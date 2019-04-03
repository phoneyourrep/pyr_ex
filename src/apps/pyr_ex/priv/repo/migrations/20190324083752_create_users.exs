defmodule PYREx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string
      add :website, :string
      add :organization, :string
      add :is_authorized, :boolean, default: true, null: false
      add :intended_usage, :text

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
