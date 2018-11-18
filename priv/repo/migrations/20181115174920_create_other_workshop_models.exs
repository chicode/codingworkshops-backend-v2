defmodule Workshops.Repo.Migrations.CreateOtherWorkshopModels do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add(:name, :string)
      add(:description, :text)
      add(:index, :integer)
      add(:workshop_id, references(:lessons, on_delete: :delete_all))

      timestamps()
    end

    create(unique_index(:lessons, [:index, :workshop_id], name: :lesson_index))

    create table(:slides) do
      add(:name, :string)
      add(:description, :text)
      add(:index, :integer)
      add(:lesson_id, references(:slides, on_delete: :delete_all))

      timestamps()
    end

    create(unique_index(:slides, [:index, :lesson_id], name: :slide_index))

    create table(:directions) do
      add(:description, :text)
      add(:index, :integer)
      add(:slide_id, references(:directions, on_delete: :delete_all))

      timestamps()
    end

    create(unique_index(:directions, [:index, :slide_id], name: :direction_index))
  end
end
