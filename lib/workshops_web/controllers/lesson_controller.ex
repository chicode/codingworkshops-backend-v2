defmodule WorkshopsWeb.LessonController do
  use WorkshopsWeb, :controller

  alias Workshops.{Lesson, Workshop, Repo}

  action_fallback(WorkshopsWeb.FallbackController)

  def show(conn, %{"slug" => workshop_slug, "index" => index}) do
    Lesson
    |> where([l], l.index == ^index)
    |> join(:inner, [l], w in assoc(l, :workshop))
    |> where([l, w], w.slug == ^workshop_slug)
    |> preload(slides: [:directions])
    |> Repo.one()
    |> Lesson.bare([:slides])
  end
end
