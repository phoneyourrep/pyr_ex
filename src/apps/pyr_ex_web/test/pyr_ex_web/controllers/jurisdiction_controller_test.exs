defmodule PYRExWeb.JurisdictionControllerTest do
  use PYRExWeb.ConnCase

  alias PYREx.Geographies
  alias PYREx.Geographies.Jurisdiction

  @create_attrs %{
    fips: "some fips",
    geoid: "some geoid",
    name: "some name",
    statefp: "some statefp",
    type: "some type"
  }
  @update_attrs %{
    fips: "some updated fips",
    geoid: "some updated geoid",
    name: "some updated name",
    statefp: "some updated statefp",
    type: "some updated type"
  }
  @invalid_attrs %{fips: nil, geoid: nil, name: nil, statefp: nil, type: nil}

  @shape_attrs %{
    geoid: "some geoid",
    geom: %Geo.Point{coordinates: {1.0, 2.0}, srid: PYRExShapefile.srid()}
  }

  def fixture(:jurisdiction) do
    {:ok, jurisdiction} = Geographies.create_jurisdiction(@create_attrs)
    jurisdiction
  end

  def fixture(:shape) do
    {:ok, shape} = Geographies.create_shape(@shape_attrs)
    shape
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all jurisdictions", %{conn: conn} do
      conn = get(conn, Routes.jurisdiction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []

      fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :index))
      assert [%{
        "id" => id,
        "fips" => "some fips",
        "geoid" => "some geoid",
        "name" => "some name",
        "statefp" => "some statefp",
        "type" => "some type"
      }] = json_response(conn, 200)["data"]
    end

    test "lists jurisdictions for lat and lon", %{conn: conn} do
      fixture(:jurisdiction)
      fixture(:shape)

      conn = get(conn, Routes.jurisdiction_path(conn, :index, lat: "1.0", lon: "2.0"))
      assert [%{
        "id" => id,
        "fips" => "some fips",
        "geoid" => "some geoid",
        "name" => "some name",
        "statefp" => "some statefp",
        "type" => "some type"
      }] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.jurisdiction_path(conn, :index, lat: "2.0", lon: "2.0"))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create jurisdiction" do
    test "renders jurisdiction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.jurisdiction_path(conn, :create), jurisdiction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.jurisdiction_path(conn, :show, id))

      assert %{
               "id" => id,
               "fips" => "some fips",
               "geoid" => "some geoid",
               "name" => "some name",
               "statefp" => "some statefp",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.jurisdiction_path(conn, :create), jurisdiction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update jurisdiction" do
    setup [:create_jurisdiction]

    test "renders jurisdiction when data is valid", %{conn: conn, jurisdiction: %Jurisdiction{} = jurisdiction} do
      conn = put(conn, Routes.jurisdiction_path(conn, :update, jurisdiction), jurisdiction: @update_attrs)
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.jurisdiction_path(conn, :show, id))

      assert %{
               "id" => id,
               "fips" => "some updated fips",
               "geoid" => "some updated geoid",
               "name" => "some updated name",
               "statefp" => "some updated statefp",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, jurisdiction: jurisdiction} do
      conn = put(conn, Routes.jurisdiction_path(conn, :update, jurisdiction), jurisdiction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete jurisdiction" do
    setup [:create_jurisdiction]

    test "deletes chosen jurisdiction", %{conn: conn, jurisdiction: jurisdiction} do
      conn = delete(conn, Routes.jurisdiction_path(conn, :delete, jurisdiction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.jurisdiction_path(conn, :show, jurisdiction))
      end
    end
  end

  defp create_jurisdiction(_) do
    jurisdiction = fixture(:jurisdiction)
    {:ok, jurisdiction: jurisdiction}
  end
end
