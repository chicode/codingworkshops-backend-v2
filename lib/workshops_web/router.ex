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
      post "/users/me", UserController, :me
      get "/users/:username", UserController, :show
      post "/users", UserController, :create
      put "/users", UserController, :update
      delete "/users", UserController, :delete

      get "/workshops", WorkshopController, :index
      get "/workshops/:slug", WorkshopController, :show
      post "/workshops", WorkshopController, :create
      patch "/workshops/:id", WorkshopController, :update
      delete "/workshops/:id", WorkshopController, :delete

      post "/workshops/:id/load", WorkshopController, :load

      get "/workshops/:slug/:index", LessonController, :show

      post "/sessions", SessionController, :create
    end
  end
end
