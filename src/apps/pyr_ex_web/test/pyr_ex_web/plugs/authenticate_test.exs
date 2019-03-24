defmodule PYRExWeb.Plugs.AuthenticateTest do
  use PYRExWeb.ConnCase
  alias PYRExWeb.Plugs.Authenticate

  test "returns an error when API key is not provided" do
    conn =
      build_conn()
      |> Authenticate.call(%{})

    assert json_response(conn, 200)["errors"]["detail"] == "API key required"
  end

  test "returns an error when API key is invalid" do
    conn =
      build_conn(:get, "/api/jurisdictions", api_key: "key is invalid")
      |> Authenticate.call(%{})

    assert json_response(conn, 200)["errors"]["detail"] == "Invalid API key: key is invalid"
  end
end
