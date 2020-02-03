defmodule BrAppWeb.ReactionControllerTest do
  use BrAppWeb.ConnCase,  async: true
  alias BrApp.Reaction

  @create_attrs %{
    action: "add",
    content_id: "7488a646-e31f-11e4-aace-6003088",
    reaction_type: "fire",
    type: "reaction",
    user_id: "7488a646-e31f-11e4-aace-600308960662"
  }
  @delete_attrs %{
    action: "remove",
    content_id: "7488a646-e31f-11e4-aace-6003088",
    reaction_type: "fire",
    type: "reaction",
    user_id: "7488a646-e31f-11e4-aace-600308960662"
  }
  @invalid_attrs %{action: nil, content_id: nil, reaction_type: nil, type: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get reaction counts" do
    test "getting reaction counts given a not existent content id `foobar`", %{conn: conn} do
      conn = get(conn, "/reaction_counts/foobar")
      assert json_response(conn, 404)["error"] == "Reaction with content_id `foobar` not found"
    end
  end

  describe "create a reaction" do
    test "creating a reaction should increase the number of fires", %{conn: conn} do
      conn = post(conn, "/reaction", @create_attrs)
      assert "success" == json_response(conn, 201)["message"]

      conn = get(conn, "/reaction_counts/" <> @create_attrs.content_id)
      assert json_response(conn, 200)["content_id"] == @create_attrs.content_id
    end

    

    test "get a 400 when when requesting params are not valid", %{conn: conn} do
      conn = post(conn, "/reaction", @invalid_attrs)
      assert json_response(conn, 400)["error"] == "Bad request"
    end

    test "delete a reaction when requesting params are valid", %{conn: conn} do
      conn = post(conn, "/reaction", @create_attrs)
      assert "success" == json_response(conn, 201)["message"]
      conn = post(conn, "/reaction", @delete_attrs)
      assert json_response(conn, 201)["message"] == "success"
    end

    test "deleted reaction should return 200 with 0 fires when you query for its reaction counts", %{
      conn: conn
    } do
        conn = post(conn, "/reaction", @create_attrs)
        assert "success" == json_response(conn, 201)["message"]

        conn = post(conn, "/reaction", @delete_attrs)
        assert json_response(conn, 201)["message"] == "success"
      conn = get(conn, "/reaction_counts/" <> @delete_attrs.content_id)

      assert json_response(conn, 200)["reaction_count"]["fire"] == 0
    end
  end
end
