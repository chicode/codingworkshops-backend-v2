defmodule Workshops.Repo do
  use Ecto.Repo,
    otp_app: :workshops,
    adapter: Ecto.Adapters.Postgres
end
