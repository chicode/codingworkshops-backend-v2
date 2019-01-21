defmodule Workshops.Workshop do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @base_properties [:name, :description, :source_url, :slug, :id, :author]

  @derive {Jason.Encoder, only: @base_properties}
  schema "workshops" do
    field :name, :string
    field :description, :string
    field :source_url, :string
    field :slug, :string
    belongs_to :author, Workshops.User, foreign_key: :user_id
    has_many :lessons, Workshops.Lesson, on_replace: :delete

    timestamps()
  end

  def bare(workshop, additional \\ []) do
    workshop
    |> Map.from_struct()
    |> Map.take(@base_properties ++ additional)
  end

  def create_changeset(workshop, attrs) do
    workshop
    |> Workshops.Repo.preload([:author, :lessons])
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 1, max: 60)
    |> custom_change(:name, :slug, &slugify/1)
    |> changeset(attrs)
  end

  def update_changeset(workshop, attrs) do
    workshop
    |> Workshops.Repo.preload([:author, :lessons])
    |> changeset(attrs)
  end

  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:description, :source_url])
    |> validate_required([:description, :source_url])
    |> validate_length(:description, min: 1, max: 600)
    |> assoc_constraint(:author)
    |> custom_validation(:source_url, &valid_url?/1, "Invalid URL")
    |> cast_assoc(:lessons)
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
