defmodule Workshops.Workshops do
  @moduledoc """
  The Workshops context.
  """

  import Ecto.Query, warn: false
  alias Workshops.Repo

  alias Workshops.Workshops.Workshop

  @doc """
  Returns the list of workshop.

  ## Examples

      iex> list_workshop()
      [%Workshop{}, ...]

  """
  def list_workshop do
    Repo.all(Workshop)
  end

  @doc """
  Gets a single workshop.

  Raises `Ecto.NoResultsError` if the Workshop does not exist.

  ## Examples

      iex> get_workshop!(123)
      %Workshop{}

      iex> get_workshop!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workshop!(id), do: Repo.get!(Workshop, id)

  @doc """
  Creates a workshop.

  ## Examples

      iex> create_workshop(%{field: value})
      {:ok, %Workshop{}}

      iex> create_workshop(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workshop(attrs \\ %{}) do
    %Workshop{}
    |> Workshop.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workshop.

  ## Examples

      iex> update_workshop(workshop, %{field: new_value})
      {:ok, %Workshop{}}

      iex> update_workshop(workshop, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workshop(%Workshop{} = workshop, attrs) do
    workshop
    |> Workshop.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Workshop.

  ## Examples

      iex> delete_workshop(workshop)
      {:ok, %Workshop{}}

      iex> delete_workshop(workshop)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workshop(%Workshop{} = workshop) do
    Repo.delete(workshop)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workshop changes.

  ## Examples

      iex> change_workshop(workshop)
      %Ecto.Changeset{source: %Workshop{}}

  """
  def change_workshop(%Workshop{} = workshop) do
    Workshop.changeset(workshop, %{})
  end
end
