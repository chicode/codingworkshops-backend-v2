defmodule WorkshopsWeb.Auth do
  import Plug.Conn
  import WorkshopsWeb.Helpers

  def authenticate(username, password) do
    user = Workshops.Repo.get_by(Workshops.User, username: username)

    cond do
      user && Comeonin.Bcrypt.checkpw(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, :not_found}
    end
  end

  def process_token(conn, _opts) do
    with %{"jwt" => jwt} <- conn.params,
         {:ok, claims} <- Workshops.Guardian.decode_and_verify(jwt) do
      {:ok, user} = Workshops.Guardian.resource_from_claims(claims)
      assign(conn, :user, user)
    else
      _ -> assign(conn, :user, nil)
    end
  end

  def force_authenticated(conn, _opts) do
    if is_nil(conn.assigns.user) do
      conn
      |> send_json(:bad_request, %{error: "Missing jwt token."})
      |> halt
    else
      conn
    end
  end
end
