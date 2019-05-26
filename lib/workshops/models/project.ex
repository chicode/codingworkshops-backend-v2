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
    field :public, :boolean
    field :language, :string
    belongs_to :author, Workshops.User, foreign_key: :user_id

    timestamps()
  end

  def bare(project, additional \\ []) do
    project
    |> Map.from_struct()
    |> Map.take(@base_properties ++ additional)
  end

  def changeset(project, attrs) do
    alias Workshops.Repo

    project
    |> Repo.preload([:author])
    |> cast(attrs, [:name, :code, :spritesheet, :tilesheet, :flags, :public, :language])
    |> validate_required([:name, :code, :spritesheet, :tilesheet, :flags, :public, :language])
    |> custom_change_all(:name, fn %{data: data, changes: changes} ->
      if is_nil(Map.get(changes, :name)) do
        project_number = data.author |> Repo.preload(:projects) |> Map.get(:projects) |> length
        "untitled #{project_number}"
        # TODO project_number = number of projects with untitled in them
      else
        changes.name
      end
    end)
    |> default(:public, false)
    |> validate_length(:name, min: 1, max: 60)
    |> custom_change(:name, :slug, &slugify/1)
    |> assoc_constraint(:author)
  end
end
