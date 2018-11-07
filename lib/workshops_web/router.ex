defmodule WorkshopsWeb.Router do
  use WorkshopsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WorkshopsWeb do
    pipe_through :api
  end
end
