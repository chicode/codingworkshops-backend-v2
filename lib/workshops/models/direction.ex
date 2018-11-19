defmodule Workshops.Direction do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @derive {Jason.Encoder, only: [:id, :description, :index]}
  schema "directions" do
    field :description, :string
    field :index, :integer
    belongs_to :slide, Workshops.Slide

    timestamps()
  end

  def changeset(direction, attrs) when is_map(direction) do
    direction
    |> cast(attrs, [:description, :index])
    |> validate_required([:description, :index])
    |> unique_constraint(:index, name: :direction_index)
    |> assoc_constraint(:slide)
  end
end
