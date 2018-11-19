defmodule Workshops.Lesson do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @derive {Jason.Encoder, only: [:id, :name, :description, :index, :slides]}
  schema "lessons" do
    field :name, :string
    field :description, :string
    field :index, :integer
    belongs_to :workshop, Workshops.Workshop
    has_many :slides, Workshops.Slide

    timestamps()
  end

  def changeset(lesson, attrs) do
    lesson
    |> Workshops.Repo.preload(:slides)
    |> cast(attrs, [:name, :description, :index])
    |> validate_required([:name, :description, :index])
    |> unique_constraint(:index, name: :lesson_index)
    |> validate_length(:name, min: 1, max: 60)
    |> assoc_constraint(:workshop)
    |> cast_assoc(:slides)
  end
end
