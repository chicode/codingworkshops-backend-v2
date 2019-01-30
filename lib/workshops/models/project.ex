defmodule Workshops.Project do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @base_properties [:id, :name, :slug, :code, :spritesheet, :tilesheet, :flags]

  @derive {Jason.Encoder, only: @base_properties}
  schema "projects" do
    field :name, :string
    field :slug, :string
    field :code, :string
    field :spritesheet, :string
    field :tilesheet, :string
    field :flags, :string
    belongs_to :author, Workshops.User, foreign_key: :user_id

    timestamps()
  end

  def bare(project, additional \\ []) do
    project
    |> Map.from_struct()
    |> Map.take(@base_properties ++ additional)
  end

  def changeset(project, attrs) do
    project
    |> Workshops.Repo.preload([:author])
    |> cast(attrs, [:name, :code, :spritesheet, :tilesheet, :flags])
    |> validate_required([:name, :code, :spritesheet, :tilesheet, :flags])
    |> validate_length(:name, min: 1, max: 60)
    |> custom_change(:name, :slug, &slugify/1)
    |> assoc_constraint(:author)
  end
end
