defmodule WorkshopsWeb.UserController do
  use WorkshopsWeb, :controller

  alias Workshops.{User, Repo}

  action_fallback WorkshopsWeb.FallbackController

  plug :authenticate_user when action in [:update, :delete]

  def index(conn, _params) do
    users = Repo.all(User)
    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    json(conn, user)
  end

  def create(_conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    Repo.insert(changeset)
  end

  def update(conn, %{"user" => user_params}) do
    changeset = User.changeset(conn.assigns.user, user_params)

    Repo.update(changeset)
  end

  def delete(conn) do
    Repo.delete(conn.assigns.user)
  end
end
