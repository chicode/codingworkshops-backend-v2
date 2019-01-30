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
      scope "/workshops" do
        get "/", WorkshopController, :index
        get "/:slug", WorkshopController, :show
        post "/", WorkshopController, :create
        patch "/:id", WorkshopController, :update
        delete "/:id", WorkshopController, :delete

        post "/:id/load", WorkshopController, :load

        get "/:slug/:index", LessonController, :show
      end

      scope "/users" do
        get "/", UserController, :index
        post "/me", UserController, :me
        get "/:username", UserController, :show
        post "/", UserController, :create
        patch "/", UserController, :update
        delete "/", UserController, :delete
      end

      scope "/projects" do
        get "/", ProjectController, :index
        get "/:username", ProjectController, :user_index
        get "/:username/:slug", ProjectController, :show
        post "/", ProjectController, :create
        patch "/:id", ProjectController, :update
        delete "/:id", ProjectController, :delete
      end

      post "/sessions", SessionController, :create
    end
  end
end
