defmodule PYRExWeb.JurisdictionControllerTest do
  use PYRExWeb.ConnCase

  alias PYREx.Geographies
  alias PYRExWeb.Authenticator

  @create_attrs %{
    fips: "some fips",
    geoid: "some geoid",
    name: "some name",
    statefp: "some statefp",
    type: "some type"
  }

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
    conn = put_req_header(conn, "accept", "application/json")
    key = Authenticator.generate_key(44)
    {:ok, conn: conn, key: key}
  end

  describe "show" do
    test "shows one jursidiction", %{conn: conn, key: key} do
      j = fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :show, j.id), api_key: key)

      assert %{
               "id" => id,
               "fips" => "some fips",
               "geoid" => "some geoid",
               "name" => "some name",
               "statefp" => "some statefp",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "index" do
    test "lists all jurisdictions", %{conn: conn, key: key} do
      conn = get(conn, Routes.jurisdiction_path(conn, :index), api_key: key)
      assert json_response(conn, 200)["data"] == []

      fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :index), api_key: key)

      assert [
               %{
                 "id" => id,
                 "fips" => "some fips",
                 "geoid" => "some geoid",
                 "name" => "some name",
                 "statefp" => "some statefp",
                 "type" => "some type"
               }
             ] = json_response(conn, 200)["data"]
    end

    test "lists jurisdictions for lat and lon", %{conn: conn, key: key} do
      fixture(:jurisdiction)
      fixture(:shape)

      conn =
        get(conn, Routes.jurisdiction_path(conn, :index, lat: "1.0", lon: "2.0", api_key: key))

      assert [
               %{
                 "id" => id,
                 "fips" => "some fips",
                 "geoid" => "some geoid",
                 "name" => "some name",
                 "statefp" => "some statefp",
                 "type" => "some type"
               }
             ] = json_response(conn, 200)["data"]

      conn =
        get(conn, Routes.jurisdiction_path(conn, :index, lat: "2.0", lon: "2.0", api_key: key))

      assert json_response(conn, 200)["data"] == []
    end
  end
end
