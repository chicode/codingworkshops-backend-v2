# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Workshops.Repo.insert!(%Workshops.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Workshops.Repo
alias Workshops.User
alias Workshops.Workshop

if workshop = Repo.get_by(Workshop, name: "Nico") do
  Repo.delete!(workshop)
end

if user = Repo.get_by(User, username: "username") do
  Repo.delete!(user)
end

User.create_changeset(%User{}, %{
  username: "username",
  password: "123456",
  email: "test@test.com"
})
|> Repo.insert!()
|> Ecto.build_assoc(:workshops)
|> Workshop.create_changeset(%{
  name: "Nico",
  description: "cool workshop",
  source_url: "https://raw.githubusercontent.com/chicode/workshops/master/nico.yaml"
})
|> Repo.insert!()
|> WorkshopsWeb.WorkshopController.load_workshop()
|> IO.inspect()
