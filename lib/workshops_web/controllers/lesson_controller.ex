defmodule WorkshopsWeb.LessonController do
  use WorkshopsWeb, :controller

  alias Workshops.{Lesson, Repo}

  def show(conn, %{"id" => id}) do
    lesson =
      Lesson
      |> Repo.get!(id)
      |> Repo.preload(slides: [:directions])

    render(conn, "show.json", lesson: lesson)
  end
end
