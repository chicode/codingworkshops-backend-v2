defmodule WorkshopsWeb.ProjectController do
  use WorkshopsWeb, :controller

  alias Workshops.{Project, Repo}

  action_fallback(WorkshopsWeb.FallbackController)

  plug :force_authenticated when action not in [:index, :show]

  def index(conn, _params) do
    Project
    |> Repo.all()
    |> Repo.preload(:author)
    |> Enum.map(&Workshop.bare(&1, [:author]))
  end

  def user_index(conn, %{"username" => username}) do
    Project
    |> join(:inner, [p], a in assoc(p, :author))
    |> where([p, a], a.username == ^username)
    |> preload([p, a], author: a)
    |> Repo.all()
  end

  def show(conn, %{"username" => username, "slug" => slug}) do
    Project
    |> where([p], p.slug == ^slug)
    |> join(:inner, [p], a in assoc(p, :author))
    |> where([p, a], a.username == ^username)
    |> preload([p, a], author: a)
    |> Repo.one()
  end

  def create(conn, %{"project" => project_params}) do
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:projects)
      |> Project.changeset(project_params)

    Repo.insert(changeset) |> IO.inspect()
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Repo.get!(Project, id)

    with {:ok} <- verify_ownership(conn, project) do
      changeset = Project.changeset(project, project_params)
      Repo.update(changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)

    with {:ok} <- verify_ownership(conn, project) do
      Repo.delete(project) |> IO.inspect()
    end
  end

  defp verify_ownership(conn, project) do
    project = Repo.preload(project, :author)

    if project.author == conn.assigns.user do
      {:ok}
    else
      {:error, :unauthorized}
    end
  end
end
