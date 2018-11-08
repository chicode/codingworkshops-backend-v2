defmodule Workshops.WorkshopsTest do
  use Workshops.DataCase

  alias Workshops.Workshops

  describe "workshop" do
    alias Workshops.Workshops.Workshop

    @valid_attrs %{description: "some description", is_draft: true, name: "some name", slug: "some slug", source_url: "some source_url"}
    @update_attrs %{description: "some updated description", is_draft: false, name: "some updated name", slug: "some updated slug", source_url: "some updated source_url"}
    @invalid_attrs %{description: nil, is_draft: nil, name: nil, slug: nil, source_url: nil}

    def workshop_fixture(attrs \\ %{}) do
      {:ok, workshop} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Workshops.create_workshop()

      workshop
    end

    test "list_workshop/0 returns all workshop" do
      workshop = workshop_fixture()
      assert Workshops.list_workshop() == [workshop]
    end

    test "get_workshop!/1 returns the workshop with given id" do
      workshop = workshop_fixture()
      assert Workshops.get_workshop!(workshop.id) == workshop
    end

    test "create_workshop/1 with valid data creates a workshop" do
      assert {:ok, %Workshop{} = workshop} = Workshops.create_workshop(@valid_attrs)
      assert workshop.description == "some description"
      assert workshop.is_draft == true
      assert workshop.name == "some name"
      assert workshop.slug == "some slug"
      assert workshop.source_url == "some source_url"
    end

    test "create_workshop/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workshops.create_workshop(@invalid_attrs)
    end

    test "update_workshop/2 with valid data updates the workshop" do
      workshop = workshop_fixture()
      assert {:ok, %Workshop{} = workshop} = Workshops.update_workshop(workshop, @update_attrs)
      assert workshop.description == "some updated description"
      assert workshop.is_draft == false
      assert workshop.name == "some updated name"
      assert workshop.slug == "some updated slug"
      assert workshop.source_url == "some updated source_url"
    end

    test "update_workshop/2 with invalid data returns error changeset" do
      workshop = workshop_fixture()
      assert {:error, %Ecto.Changeset{}} = Workshops.update_workshop(workshop, @invalid_attrs)
      assert workshop == Workshops.get_workshop!(workshop.id)
    end

    test "delete_workshop/1 deletes the workshop" do
      workshop = workshop_fixture()
      assert {:ok, %Workshop{}} = Workshops.delete_workshop(workshop)
      assert_raise Ecto.NoResultsError, fn -> Workshops.get_workshop!(workshop.id) end
    end

    test "change_workshop/1 returns a workshop changeset" do
      workshop = workshop_fixture()
      assert %Ecto.Changeset{} = Workshops.change_workshop(workshop)
    end
  end
end
