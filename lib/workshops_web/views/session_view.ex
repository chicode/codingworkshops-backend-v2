defmodule WorkshopsWeb.SessionView do
  use WorkshopsWeb, :view

  def render("show.json", %{jwt: jwt, user: user}) do
    %{
      jwt: jwt,
      user: user
    }
  end
end
