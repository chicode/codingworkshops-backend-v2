defmodule Workshops.Repo.Migrations.CreateWorkshop do
  use Ecto.Migration

  def change do
    create table(:workshops) do
      add(:name, :string)
      add(:slug, :string)
      add(:description, :string)
      add(:source_url, :string)

      timestamps()
    end

    create(unique_index(:workshops, [:name]))
  end
end
