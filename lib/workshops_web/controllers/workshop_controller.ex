require IEx

defmodule WorkshopsWeb.WorkshopController do
  use WorkshopsWeb, :controller

  alias Workshops.{Workshop, Repo}
  alias Ecto.Multi

  action_fallback WorkshopsWeb.FallbackController

  plug :authenticate_user when action not in [:index, :show]

  def index(conn, _params) do
    workshops =
      Workshop
      |> Repo.all()
      |> Repo.preload(:user)

    json(conn, workshops)
  end

  def show(conn, %{"id" => id}) do
    workshop =
      Workshop |> Repo.get!(id) |> Repo.preload([:user, :lessons]) |> Workshop.bare([:lessons])

    json(conn, workshop)
  end

  def create(conn, %{"workshop" => workshop_params}) do
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:workshops)
      |> Workshop.changeset(workshop_params)

    with {:ok, %Workshop{}} <- Repo.insert(changeset) do
      send_resp(conn, :created, "")
    end
  end

  def update(conn, %{"id" => id, "workshop" => workshop_params}) do
    workshop = Repo.get!(Workshop, id)
    changeset = Workshop.changeset(workshop, workshop_params)

    with {:ok} <- verify_ownership(conn, workshop),
         {:ok, %Workshop{}} <- Repo.update(changeset) do
      send_resp(conn, :ok, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)

    with {:ok} <- verify_ownership(conn, workshop),
         {:ok, %Workshop{}} <- Repo.delete(workshop) do
      send_resp(conn, :ok, "")
    end
  end

  def load(conn, %{"id" => id}) do
    workshop = Repo.get!(Workshop, id)

    with {:ok} <- verify_ownership(conn, workshop) do
      case HTTPoison.get(workshop.source_url) do
        {:ok, %HTTPoison.Response{body: body}} ->
          case YamlElixir.read_from_string(body) do
            {:ok, yaml} ->
              # this check is necessary in case the yaml has numbered keys
              if yaml |> Map.keys() |> Enum.all?(&is_binary/1) do
                case reset_workshop(workshop, yaml) do
                  {:ok, _} -> {:ok}
                  {:error, _name, changeset, _value} -> {:error, changeset}
                end
              else
                {:error, "Malformed yaml"}
              end

            {:error} ->
              {:error, "Malformed yaml"}
          end

        {:error, _error} ->
          {:error, "Could not reach the workshop source."}
      end
    end
  end

  defp reset_workshop(workshop, data) do
    import Ecto.Query

    changeset = Workshop.changeset(workshop, data)

    Multi.new()
    |> Multi.delete_all(
      :delete,
      from(l in Workshops.Lesson,
        join: w in assoc(l, :workshop),
        where: w.id == ^workshop.id
      )
    )
    |> Multi.update(-1, changeset)
    |> load_section(data, -1, [
      {Workshops.Lesson, :lessons},
      {Workshops.Slide, :slides},
      {Workshops.Direction, :directions}
    ])
    |> Repo.transaction()
  end

  defp load_section(multi, data, change_i, [{child_module, parent_children} | sections]) do
    Multi.merge(multi, fn changes ->
      # IEx.pry()

      data
      # the yaml needs to store each child section as the assoc name (eg "lessons" in workshop)
      |> Map.get(Atom.to_string(parent_children))
      |> Enum.with_index()
      |> Enum.reduce(Multi.new(), fn {child, i}, multi ->
        changeset =
          apply(child_module, :changeset, [
            Ecto.build_assoc(changes[change_i], parent_children),
            Map.merge(
              # directions are written as strings, not objects,
              # because currently their only property is a description
              if is_map(child) do
                child
              else
                %{"description" => child}
              end,
              %{"index" => i}
            )
          ])

        IEx.pry()

        multi
        # i is the name of the change that is then
        |> Multi.insert(i, changeset)
        # passed on to the next function call into parameter change_i
        |> load_section(child, i, sections)
      end)
    end)
  end

  defp load_section(multi, _data, _change_i, []) do
    multi
  end

  defp verify_ownership(conn, workshop) do
    workshop = Repo.preload(workshop, :user)

    if workshop.user == conn.assigns.user do
      {:ok}
    else
      {:error, :unauthorized}
    end
  end
end
