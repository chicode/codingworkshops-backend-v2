defmodule WorkshopsWeb.WorkshopControllerTest do
  use WorkshopsWeb.ConnCase

  alias Workshops.Workshops
  alias Workshops.Workshops.Workshop

  @create_attrs %{
    description: "some description",
    is_draft: true,
    name: "some name",
    slug: "some slug",
    source_url: "some source_url"
  }
  @update_attrs %{
    description: "some updated description",
    is_draft: false,
    name: "some updated name",
    slug: "some updated slug",
    source_url: "some updated source_url"
  }
  @invalid_attrs %{description: nil, is_draft: nil, name: nil, slug: nil, source_url: nil}

  def fixture(:workshop) do
    {:ok, workshop} = Workshops.create_workshop(@create_attrs)
    workshop
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workshop", %{conn: conn} do
      conn = get(conn, Routes.workshop_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workshop" do
    test "renders workshop when data is valid", %{conn: conn} do
      conn = post(conn, Routes.workshop_path(conn, :create), workshop: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.workshop_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_draft" => true,
               "name" => "some name",
               "slug" => "some slug",
               "source_url" => "some source_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.workshop_path(conn, :create), workshop: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workshop" do
    setup [:create_workshop]

    test "renders workshop when data is valid", %{conn: conn, workshop: %Workshop{id: id} = workshop} do
      conn = put(conn, Routes.workshop_path(conn, :update, workshop), workshop: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.workshop_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "is_draft" => false,
               "name" => "some updated name",
               "slug" => "some updated slug",
               "source_url" => "some updated source_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workshop: workshop} do
      conn = put(conn, Routes.workshop_path(conn, :update, workshop), workshop: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workshop" do
    setup [:create_workshop]

    test "deletes chosen workshop", %{conn: conn, workshop: workshop} do
      conn = delete(conn, Routes.workshop_path(conn, :delete, workshop))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.workshop_path(conn, :show, workshop))
      end
    end
  end

  defp create_workshop(_) do
    workshop = fixture(:workshop)
    {:ok, workshop: workshop}
  end
end
