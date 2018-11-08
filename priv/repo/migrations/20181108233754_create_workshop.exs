defmodule Workshops.Repo.Migrations.CreateWorkshop do
  use Ecto.Migration

  def change do
    create table(:workshop) do
      add :name, :string
      add :slug, :string
      add :description, :string
      add :is_draft, :boolean, default: false, null: false
      add :source_url, :string

      timestamps()
    end

  end
end
