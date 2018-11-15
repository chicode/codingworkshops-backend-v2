defmodule Workshops.Workshop do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @derive {Jason.Encoder, only: [:name, :description, :source_url, :slug, :id]}
  schema "workshops" do
    field :name, :string
    field :description, :string
    field :source_url, :string
    field :slug, :string
    belongs_to :user, Workshops.User

    timestamps()
  end

  def changeset(workshop, attrs) do
    workshop
    |> cast(attrs, [:name, :description, :source_url])
    |> validate_required([:name, :description, :source_url])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 1, max: 30)
    |> assoc_constraint(:user)
    |> custom_validation(:source_url, &valid_url?/1, "Invalid URL")
    |> custom_change(:name, :slug, &slugify/1)
  end

  defp valid_url?(url) do
    ~r/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
    |> Regex.match?(url)
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
