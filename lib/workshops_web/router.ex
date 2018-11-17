defmodule WorkshopsWeb.Router do
  use WorkshopsWeb, :router
  import WorkshopsWeb.Auth, only: [process_token: 2]

  pipeline :api do
    plug :accepts, ["json"]
    plug :process_token
  end

  scope "/api", WorkshopsWeb do
    pipe_through :api

    scope "/v1" do
      resources "/users", UserController, except: [:new, :edit]
      resources "/workshops", WorkshopController, except: [:new, :edit]
      resources "/lessons", LessonController, only: [:show]
      post "/workshops/:id/load", WorkshopController, :load
      post "/sessions", SessionController, :create
    end
  end
end
