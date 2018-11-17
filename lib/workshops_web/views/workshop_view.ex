defmodule WorkshopsWeb.WorkshopView do
  use WorkshopsWeb, :view
  alias WorkshopsWeb.WorkshopView

  def render("index.json", %{workshops: workshops}) do
    %{data: render_many(workshops, WorkshopView, "workshop.json")}
  end

  def render("show.json", %{workshop: workshop}) do
    %{data: render_one(workshop, WorkshopView, "workshop.json")}
  end

  def render("workshop.json", %{workshop: workshop}) do
    require IEx
  end
end
