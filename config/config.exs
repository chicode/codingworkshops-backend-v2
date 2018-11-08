# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :workshops,
  ecto_repos: [Workshops.Repo]

# Configures the endpoint
config :workshops, WorkshopsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "igYwRylVVv7iZM7cBuJkWB5kyvuKdOnZV3OvGn+UnkuX0bv4Hq23+et6bvI4bxtP",
  render_errors: [view: WorkshopsWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Workshops.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :workshops, Workshops.Guardian,
  issuer: "workshops",
  secret_key: "BHaapsNhws+7EB/4h+PY4ColK0j+r21PVm+NaofwEJnvBFzKuHRoAPwu/N5dK3QB"
