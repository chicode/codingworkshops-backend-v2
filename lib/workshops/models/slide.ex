defmodule Workshops.Slide do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @base_properties [:id, :name, :description, :index, :directions]

  @derive {Jason.Encoder, only: @base_properties}
  schema "slides" do
    field :name, :string
    field :description, :string
    field :index, :integer
    belongs_to :lesson, Workshops.Lesson
    has_many :directions, Workshops.Direction

    timestamps()
  end

  def changeset(slide, attrs) do
    slide
    |> Workshops.Repo.preload(:directions)
    |> cast(attrs, [:name, :description, :index])
    |> validate_required([:name, :description, :index])
    |> unique_constraint(:index, name: :slide_index)
    |> validate_length(:name, min: 1, max: 60)
    |> assoc_constraint(:lesson)
    |> cast_assoc(:directions)
  end
end
