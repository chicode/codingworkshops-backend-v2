defmodule Workshops.Slide do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @derive {Jason.Encoder, only: [:id, :name, :description, :index, :directions]}
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
    |> cast(attrs, [:name, :description, :index])
    |> validate_required([:name, :description, :index])
    |> unique_constraint(:index, name: :slide_index)
    |> validate_length(:name, min: 1, max: 60)
    |> validate_length(:description, min: 1, max: 600)
    |> assoc_constraint(:lesson)
  end
end
