defmodule WorkshopsWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WorkshopsWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, &WorkshopsWeb.ErrorHelpers.translate_error/1)

    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: errors})
  end

  def call(conn, {:error, status}) when is_atom(status) do
    conn
    |> send_resp(status, "")
  end

  def call(conn, {:error, error}) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: error})
  end

  def call(conn, :ok) do
    conn
    |> send_resp(:ok, "")
  end

  def call(conn, {:ok, _}) do
    conn
    |> send_resp(:ok, "")
  end
end
