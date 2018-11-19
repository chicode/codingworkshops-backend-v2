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
      get "/users", UserController, :index
      get "/users/:id", UserController, :show
      post "/users", UserController, :create
      put "/users", UserController, :update
      delete "/users", UserController, :delete

      resources "/workshops", WorkshopController, except: [:new, :edit]
      post "/workshops/:id/load", WorkshopController, :load

      get "/lessons/:id", LessonController, :show

      post "/sessions", SessionController, :create
    end
  end
end
