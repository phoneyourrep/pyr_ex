defmodule PYRExWeb.HomeControllerTest do
  use PYRExWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Phone Your Rep"
  end
end
