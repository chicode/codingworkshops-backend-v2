defmodule Workshops.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: false)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:bio, :text)
      add(:username, :string, null: false)

      timestamps()
    end

    create(unique_index(:users, [:username]))
  end
end
