defmodule WorkshopsWeb.UserController do
  use WorkshopsWeb, :controller

  alias Workshops.User
  alias Workshops.Repo

  action_fallback WorkshopsWeb.FallbackController

  plug :authenticate_user when action not in [:index, :show, :create]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    with {:ok, %User{} = user} <- Repo.insert(changeset) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    with {:ok, %User{} = user} <- Repo.update(changeset) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    with {:ok, %User{}} <- Repo.delete(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
