defmodule PYRExWeb.Plugs.AuthenticateTest do
  use PYRExWeb.ConnCase
  use PYREx.TestFixtures, [:user]
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

  test "returns an error when API key is unauthorized" do
    user = user_fixture(%{is_authorized: false})
    key = PYRExWeb.Authenticator.generate_key(user)

    conn =
      build_conn(:get, "/api/jurisdictions", api_key: key)
      |> Authenticate.call(%{})

    assert json_response(conn, 200)["errors"]["detail"] == "API key is unauthorized due to misuse"
  end
end
