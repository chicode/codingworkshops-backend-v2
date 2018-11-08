defmodule Workshops.Workshops.Workshop do
  use Ecto.Schema
  import Ecto.Changeset


  schema "workshop" do
    field :description, :string
    field :is_draft, :boolean, default: false
    field :name, :string
    field :slug, :string
    field :source_url, :string

    timestamps()
  end

  @doc false
  def changeset(workshop, attrs) do
    workshop
    |> cast(attrs, [:name, :slug, :description, :is_draft, :source_url])
    |> validate_required([:name, :slug, :description, :is_draft, :source_url])
  end
end
