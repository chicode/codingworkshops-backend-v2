defmodule WorkshopsWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

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
         {:ok, user} <- Workshops.Guardian.decode_and_verify(jwt) do
      assign(conn, :user, user)
    else
      _ -> assign(conn, :user, nil)
    end
  end

  def authenticate_user(conn, _opts) do
    if is_nil(conn.assigns.user) do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Missing jwt token."})
    else
      conn
    end
  end
end
