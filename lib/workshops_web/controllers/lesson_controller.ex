defmodule WorkshopsWeb.LessonController do
  use WorkshopsWeb, :controller

  alias Workshops.{Lesson, Workshop, Repo}

  def show(conn, %{"slug" => workshop_slug, "index" => index}) do
    lesson =
      Repo.one(
        from l in Lesson,
          where: l.index == ^index,
          join: w in assoc(l, :workshop),
          where: w.slug == ^workshop_slug,
          preload: [slides: [:directions]]
      )

    json(conn, lesson)
  end
end
