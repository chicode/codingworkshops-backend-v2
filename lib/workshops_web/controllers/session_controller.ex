defmodule WorkshopsWeb.SessionController do
  use WorkshopsWeb, :controller

  alias Workshops.Guardian

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case WorkshopsWeb.Auth.authenticate(username, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)

      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", error: "Incorrect email or password!")
    end
  end
end