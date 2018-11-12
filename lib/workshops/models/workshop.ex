defmodule Workshops.Workshop do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :description, :source_url, :slug]}
  schema "workshops" do
    field :name, :string
    field :description, :string
    field :source_url, :string
    field :slug, :string

    timestamps()
  end

  def changeset(workshop, attrs) do
    workshop
    |> cast(attrs, [:name, :description, :source_url])
    |> validate_required([:name, :description, :source_url])
    |> unique_constraint(:name)
    |> validate_url(:source_url)
    |> validate_length(:name, min: 1, max: 30)
    |> slugify_name()
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, url ->
      if valid_url?(url), do: [], else: [{field, "Invalid URL"}]
    end)
  end

  defp valid_url?(url) do
    ~r/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
    |> Regex.match?(url)
  end

  defp slugify_name(changeset) do
    if name = get_change(changeset, :name) do
      put_change(changeset, :slug, slugify(name))
    else
      changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
