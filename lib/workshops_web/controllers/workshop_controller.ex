defmodule WorkshopsWeb.WorkshopController do
  use WorkshopsWeb, :controller

  alias Workshops.{Workshop, Repo}

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

    with {:ok, %Workshop{} = workshop} <- Repo.insert(changeset) do
      send_resp(conn, :created, "")
    end
  end

  def update(conn, %{"id" => id, "workshop" => workshop_params}) do
    workshop = Repo.get!(Workshop, id)
    changeset = Workshop.changeset(workshop, workshop_params)

    with {:ok} <- verify_ownership(conn, workshop),
         {:ok} <- Repo.update(changeset) do
      send_resp(conn, :ok, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)

    with {:ok} <- verify_ownership(conn, workshop),
         {:ok, %Workshop{}} <- Repo.delete(workshop) do
      send_resp(conn, :ok, "")
    end
  end

  def load(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)

    with {:ok} <- verify_ownership(conn, workshop) do
      case HTTPoison.get(workshop.source_url) do
        {:ok, %HTTPoison.Response{body: body}} ->
          case YamlElixir.read_from_string(body) do
            {:ok, yaml} ->
              changeset = Workshop.changeset(workshop, yaml)

              with {:ok, workshop} <- Repo.update(changeset) do
                load_section(workshop, [
                  {Lesson, :lessons},
                  {Slide, :slides},
                  {Direction, :directions}
                ])
              end

            {:error} ->
              {:error, "Malformed yaml"}
          end

        {:error, _error} ->
          {:error, "Could not reach the workshop source."}
      end
    end
  end

  defp load_section(parent, [{child_module, parent_children} | sections]) do
    parent
    |> Repo.preload(parent_children)
    |> Map.get(parent_children)
    |> Enum.with_index()
    |> Enum.each(fn {i, child} ->
      changeset =
        apply(child_module, :changeset, [
          Ecto.build_assoc(parent, parent_children),
          %{child | index: i}
        ])

      with {:ok, item} = Repo.insert(changeset) do
        load_section(item, sections)
      end
    end)
  end

  defp load_section(_parent, []) do
    {:ok}
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
