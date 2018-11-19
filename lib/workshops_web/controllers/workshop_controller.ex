require IEx

defmodule WorkshopsWeb.WorkshopController do
  use WorkshopsWeb, :controller

  alias Workshops.{Workshop, Repo}
  alias Ecto.Multi

  action_fallback WorkshopsWeb.FallbackController

  plug :authenticate_user when action not in [:index, :show]

  def index(conn, _params) do
    workshops =
      Workshop
      |> Repo.all()
      |> Repo.preload(:user)

    json(conn, workshops)
  end

  def show(conn, %{"id" => id}) do
    workshop =
      Workshop |> Repo.get!(id) |> Repo.preload([:user, :lessons]) |> Workshop.bare([:lessons])

    json(conn, workshop)
  end

  def create(conn, %{"workshop" => workshop_params}) do
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:workshops)
      |> Workshop.changeset(workshop_params)

    with {:ok, _workshop} <- Repo.insert(changeset) do
      send_resp(conn, :created, "")
    end
  end

  def update(conn, %{"id" => id, "workshop" => workshop_params}) do
    workshop = Repo.get!(Workshop, id)
    changeset = Workshop.changeset(workshop, workshop_params)

    with {:ok} <- verify_ownership(conn, workshop) do
      Repo.update(changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)

    with {:ok} <- verify_ownership(conn, workshop) do
      Repo.delete(workshop)
    end
  end

  def load(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)

    with {:ok} <- verify_ownership(conn, workshop) do
      case HTTPoison.get(workshop.source_url) do
        {:ok, %HTTPoison.Response{body: body}} ->
          case YamlElixir.read_from_string(body) do
            {:ok, yaml} ->
              # this check is necessary in case the yaml has numbered keys
              if yaml |> Map.keys() |> Enum.all?(&is_binary/1) do
                workshop
                |> Workshop.changeset(format_loaded(yaml))
                |> Repo.update()
              else
                {:error, "Malformed yaml"}
              end

            {:error} ->
              {:error, "Malformed yaml"}
          end

        {:error, _error} ->
          {:error, "Could not reach the workshop source."}
      end
    end
  end

  defp format_loaded(data) when is_map(data) do
    MapExtras.get_and_update!(data, "lessons", &format_loaded/1)
  end

  defp format_loaded(data) when is_list(data) do
    data
    |> Enum.with_index()
    |> Enum.map(fn {item, i} ->
      if is_map(item) do
        child_section =
          item
          |> Map.keys()
          |> Enum.find(&Enum.member?(["slides", "directions"], &1))

        item = Map.merge(item, %{"index" => i})

        if is_nil(child_section) do
          item
        else
          MapExtras.get_and_update!(item, child_section, &format_loaded/1)
        end
      else
        # directions are written as strings, not objects,
        # because currently their only property is a description
        %{"description" => item, "index" => i}
      end
    end)
  end

  defp verify_ownership(conn, workshop) do
    workshop = Repo.preload(workshop, :user)

    if workshop.user == conn.assigns.user do
      {:ok}
    else
      {:error, :unauthorized}
    end
  end
end
