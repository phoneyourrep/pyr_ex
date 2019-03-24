defmodule PYREx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :name, :string
      add :website, :string
      add :organization, :string
      add :intended_usage, :text

      timestamps()
    end

  end
end
