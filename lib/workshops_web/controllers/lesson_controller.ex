defmodule WorkshopsWeb.LessonController do
  use WorkshopsWeb, :controller

  alias Workshops.{Lesson, Repo}

  def show(conn, %{"id" => id}) do
    lesson =
      Lesson
      |> Repo.get!(id)
      |> Repo.preload(slides: [:directions])

    conn
    |> json(lesson)
  end
end
