defmodule Workshops.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add(:name, :string)
      add(:slug, :string)
      add(:code, :text)
      add(:spritesheet, :text)
      add(:tilesheet, :text)
      add(:flags, :text)
      add(:user_id, references(:projects))

      timestamps()
    end
  end
end
