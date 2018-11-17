defmodule Workshops.Workshop do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @base_properties [:name, :description, :source_url, :slug, :id, :user]

  @derive {Jason.Encoder, only: @base_properties}
  schema "workshops" do
    field :name, :string
    field :description, :string
    field :source_url, :string
    field :slug, :string
    belongs_to :user, Workshops.User
    has_many :lessons, Workshops.Lesson

    timestamps()
  end

  def bare(workshop, additional \\ []) do
    workshop
    |> Map.from_struct()
    |> Map.take(@base_properties ++ additional)
  end

  def changeset(workshop, attrs) do
    workshop
    |> cast(attrs, [:name, :description, :source_url])
    |> validate_required([:name, :description, :source_url])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 1, max: 60)
    |> validate_length(:description, min: 1, max: 600)
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
