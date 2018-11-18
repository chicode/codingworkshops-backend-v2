defmodule WorkshopsWeb.UserController do
  use WorkshopsWeb, :controller

  alias Workshops.{User, Repo}

  action_fallback WorkshopsWeb.FallbackController

  plug :authenticate_user when action not in [:index, :show, :create]

  def index(conn, _params) do
    users = Repo.all(User)
    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    json(conn, user)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    with {:ok, _user} <- Repo.insert(changeset) do
      send_resp(conn, :created, "")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    with {:ok, _user} <- Repo.update(changeset) do
      send_resp(conn, :ok, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    with {:ok, %User{}} <- Repo.delete(user) do
      send_resp(conn, :ok, "")
    end
  end
end
