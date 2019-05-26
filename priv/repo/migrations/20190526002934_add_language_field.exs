defmodule Workshops.Repo.Migrations.AddLanguageField do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add(:language, :string)
    end
  end
end
