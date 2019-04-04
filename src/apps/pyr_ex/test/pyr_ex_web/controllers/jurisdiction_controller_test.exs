defmodule PYRExWeb.JurisdictionControllerTest do
  use PYRExWeb.ConnCase
  use PYREx.TestFixtures, [:user]
  alias PYREx.Geographies
  alias PYRExWeb.Authenticator

  @create_attrs %{
    geoid: "some geoid",
    name: "some name",
    statefp: "some statefp",
    type: "some type",
    mtfcc: "some mtfcc"
  }

  @shape_attrs %{
    geoid: "some geoid",
    mtfcc: "some mtfcc",
    geom: %Geo.Point{
      coordinates: {1.0, 2.0},
      srid: PYREx.Shapefile.srid()
    }
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
    {:ok, conn: conn}
  end

  describe "show" do
    test "shows one jursidiction", %{conn: conn} do
      j = fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :show, j.id), api_key: "test")

      assert %{
               "id" => id,
               "geoid" => "some geoid",
               "name" => "some name",
               "statefp" => "some statefp",
               "type" => "some type",
               "mtfcc" => "some mtfcc",
               "pyrgeoid" => "some mtfccsome geoid"
             } = json_response(conn, 200)["data"]
    end

    test "returns error without an api key", %{conn: conn} do
      j = fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :show, j.id))

      assert %{
               "errors" => %{
                 "detail" => "API key required"
               }
             } = json_response(conn, 200)
    end

    test "returns error with invalid api key", %{conn: conn} do
      j = fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :show, j.id), api_key: "invalid_key")

      assert %{
               "errors" => %{
                 "detail" => "Invalid API key: invalid_key"
               }
             } = json_response(conn, 200)
    end

    test "returns error with unauthorized api key", %{conn: conn} do
      user = user_fixture(%{is_authorized: false})
      key = Authenticator.generate_key(user)
      j = fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :show, j.id), api_key: key)

      assert %{
               "errors" => %{
                 "detail" => "API key is unauthorized due to misuse"
               }
             } = json_response(conn, 200)
    end
  end

  describe "index" do
    test "lists all jurisdictions", %{conn: conn} do
      conn = get(conn, Routes.jurisdiction_path(conn, :index), api_key: "test")
      assert json_response(conn, 200)["data"] == []

      fixture(:jurisdiction)
      conn = get(conn, Routes.jurisdiction_path(conn, :index), api_key: "test")

      assert [
               %{
                 "id" => id,
                 "geoid" => "some geoid",
                 "name" => "some name",
                 "statefp" => "some statefp",
                 "type" => "some type",
                 "mtfcc" => "some mtfcc",
                 "pyrgeoid" => "some mtfccsome geoid"
               }
             ] = json_response(conn, 200)["data"]
    end

    test "lists jurisdictions for lat and lon", %{conn: conn} do
      fixture(:jurisdiction)
      fixture(:shape)

      conn =
        get(conn, Routes.jurisdiction_path(conn, :index, lat: "1.0", lon: "2.0", api_key: "test"))

      assert [
               %{
                 "id" => id,
                 "geoid" => "some geoid",
                 "name" => "some name",
                 "statefp" => "some statefp",
                 "type" => "some type",
                 "mtfcc" => "some mtfcc",
                 "pyrgeoid" => "some mtfccsome geoid"
               }
             ] = json_response(conn, 200)["data"]

      conn =
        get(conn, Routes.jurisdiction_path(conn, :index, lat: "2.0", lon: "2.0", api_key: "test"))

      assert json_response(conn, 200)["data"] == []
    end

    test "returns error without an api key", %{conn: conn} do
      conn = get(conn, Routes.jurisdiction_path(conn, :index))

      assert %{
               "errors" => %{
                 "detail" => "API key required"
               }
             } = json_response(conn, 200)
    end

    test "returns error with invalid api key", %{conn: conn} do
      conn = get(conn, Routes.jurisdiction_path(conn, :index), api_key: "invalid_key")

      assert %{
               "errors" => %{
                 "detail" => "Invalid API key: invalid_key"
               }
             } = json_response(conn, 200)
    end

    test "returns error with unauthorized api key", %{conn: conn} do
      user = user_fixture(%{is_authorized: false})
      key = Authenticator.generate_key(user)
      conn = get(conn, Routes.jurisdiction_path(conn, :index), api_key: key)

      assert %{
               "errors" => %{
                 "detail" => "API key is unauthorized due to misuse"
               }
             } = json_response(conn, 200)
    end
  end
end
