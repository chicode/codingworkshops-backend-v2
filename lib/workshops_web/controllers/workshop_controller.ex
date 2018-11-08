defmodule WorkshopsWeb.WorkshopController do
  use WorkshopsWeb, :controller

  alias Workshops.Workshops
  alias Workshops.Workshops.Workshop

  action_fallback WorkshopsWeb.FallbackController

  def index(conn, _params) do
    workshop = Workshops.list_workshop()
    render(conn, "index.json", workshop: workshop)
  end

  def create(conn, %{"workshop" => workshop_params}) do
    with {:ok, %Workshop{} = workshop} <- Workshops.create_workshop(workshop_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workshop_path(conn, :show, workshop))
      |> render("show.json", workshop: workshop)
    end
  end

  def show(conn, %{"id" => id}) do
    workshop = Workshops.get_workshop!(id)
    render(conn, "show.json", workshop: workshop)
  end

  def update(conn, %{"id" => id, "workshop" => workshop_params}) do
    workshop = Workshops.get_workshop!(id)

    with {:ok, %Workshop{} = workshop} <- Workshops.update_workshop(workshop, workshop_params) do
      render(conn, "show.json", workshop: workshop)
    end
  end

  def delete(conn, %{"id" => id}) do
    workshop = Workshops.get_workshop!(id)

    with {:ok, %Workshop{}} <- Workshops.delete_workshop(workshop) do
      send_resp(conn, :no_content, "")
    end
  end
end
