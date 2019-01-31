defmodule WorkshopsWeb.ErrorView do
  use WorkshopsWeb, :view

  def render("404.json", assigns) do
    %{error: "not found"}
  end

  def render("500.json", assigns) do
    %{error: "server error"}
  end

  def render("400.json", assigns) do
    %{error: "server error"}
  end
end
