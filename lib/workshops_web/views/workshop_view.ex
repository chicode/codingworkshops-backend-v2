defmodule WorkshopsWeb.WorkshopView do
  use WorkshopsWeb, :view
  alias WorkshopsWeb.WorkshopView

  def render("index.json", %{workshop: workshop}) do
    %{data: render_many(workshop, WorkshopView, "workshop.json")}
  end

  def render("show.json", %{workshop: workshop}) do
    %{data: render_one(workshop, WorkshopView, "workshop.json")}
  end

  def render("workshop.json", %{workshop: workshop}) do
    %{id: workshop.id,
      name: workshop.name,
      slug: workshop.slug,
      description: workshop.description,
      is_draft: workshop.is_draft,
      source_url: workshop.source_url}
  end
end
