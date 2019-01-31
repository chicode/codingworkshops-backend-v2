defmodule Workshops.Repo.Migrations.CreateWorkshop do
  use Ecto.Migration

  def change do
    create table(:workshops) do
      add(:name, :string)
      add(:slug, :string)
      add(:description, :text)
      add(:source_url, :string)
      add(:user_id, references(:users))

      timestamps()
    end

    create(unique_index(:workshops, [:name]))
  end
end
