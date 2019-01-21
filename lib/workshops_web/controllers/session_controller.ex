defmodule WorkshopsWeb.SessionController do
  use WorkshopsWeb, :controller

  alias Workshops.Guardian

  action_fallback WorkshopsWeb.FallbackController

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case WorkshopsWeb.Auth.authenticate(username, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

        {:ok, %{jwt: jwt, user: user}}

      {:error, _} ->
        {:error, "Incorrect email or password!"}
    end
  end
end
