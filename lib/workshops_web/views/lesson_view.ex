defmodule WorkshopsWeb.LessonView do
  use WorkshopsWeb, :view
  alias WorkshopsWeb.LessonView

  def render("show.json", %{lesson: lesson}) do
    %{data: render_one(lesson, LessonView, "lesson.json")}
  end

  def render("lesson.json", %{lesson: lesson}) do
    lesson
  end
end
