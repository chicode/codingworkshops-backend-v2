defmodule Workshops.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Workshops.Helpers

  @base_properties [:username, :email, :bio, :id]

  @derive {Jason.Encoder, only: @base_properties}
  schema "users" do
    field :username, :string
    field :email, :string
    field :bio, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :workshops, Workshops.Workshop

    timestamps()
  end

  def bare(workshop, additional \\ []) do
    workshop
    |> Map.from_struct()
    |> Map.take(@base_properties ++ additional)
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email])
    |> validate_required([:username, :password, :email])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
    |> changeset(attrs)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :bio])
    |> custom_validation(:email, &valid_email?/1, "Invalid email address")
    |> validate_length(:password, min: 6, max: 50)
    |> custom_change(:password, :password_hash, &Comeonin.Bcrypt.hashpwsalt/1)
  end

  defp valid_email?(email) do
    ~r/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    |> Regex.match?(email)
  end
end
