defmodule WorkshopsWeb.WorkshopController do
  use WorkshopsWeb, :controller

  alias Workshops.Workshop
  alias Workshops.Repo

  action_fallback WorkshopsWeb.FallbackController

  plug :authenticate_user when action not in [:index, :show]

  def index(conn, _params) do
    workshops = Repo.all(Workshop)
    render(conn, "index.json", workshops: workshops)
  end

  def show(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)
    render(conn, "show.json", workshop: workshop)
  end

  def create(conn, %{"workshop" => workshop_params}) do
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:workshops)
      |> Workshop.changeset(workshop_params)

    with {:ok, %Workshop{} = workshop} <- Repo.insert(changeset) do
      conn
      |> put_status(:created)
      |> render("show.json", workshop: workshop)
    end
  end

  def update(conn, %{"id" => id, "workshop" => workshop_params}) do
    workshop = Repo.get!(Workshop, id)
    changeset = Workshop.changeset(workshop, workshop_params)

    with {:ok} <- verify_ownership(conn, workshop),
         {:ok, %Workshop{} = workshop} <- Repo.update(changeset) do
      render(conn, "show.json", workshop: workshop)
    end
  end

  def delete(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)

    with {:ok, %Workshop{}} <- Repo.delete(workshop) do
      send_resp(conn, :no_content, "")
    end
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
