defmodule WorkshopsWeb.UserController do
  use WorkshopsWeb, :controller

  alias Workshops.{User, Repo}

  action_fallback WorkshopsWeb.FallbackController

  plug :force_authenticated when action in [:update, :delete, :me]

  def index(conn, _params) do
    User
    |> Repo.all()
  end

  def show(conn, %{"username" => username}) do
    User
    |> Repo.get_by!(username: username)
    |> Repo.preload(workshops: [:author])
    |> User.bare([:workshops])
  end

  def me(conn, _params) do
    {:ok, conn.assigns.user}
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
