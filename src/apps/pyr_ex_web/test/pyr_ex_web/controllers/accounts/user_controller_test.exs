defmodule PYRExWeb.Accounts.UserControllerTest do
  use PYRExWeb.ConnCase
  # use Bamboo.Test, shared: true

  alias PYREx.Accounts

  @create_attrs %{
    email: "some email",
    intended_usage: "some intended_usage",
    name: "some name",
    organization: "some organization",
    website: "some website"
  }
  @update_attrs %{
    email: "some updated email",
    intended_usage: "some updated intended_usage",
    name: "some updated name",
    organization: "some updated organization",
    website: "some updated website"
  }
  @invalid_attrs %{email: nil, intended_usage: nil, name: nil, organization: nil, website: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.accounts_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.accounts_user_path(conn, :new))
      assert html_response(conn, 200) =~ "Register For an API Key"
    end
  end

  describe "create user" do
    test "redirects to home when data is valid", %{conn: conn} do
      conn = post(conn, Routes.accounts_user_path(conn, :create), user: @create_attrs)
      assert %{"info" => "Check your email some email for your new API key"} = get_flash(conn)
      assert redirected_to(conn) == "/"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.accounts_user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Register For an API Key"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.accounts_user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.accounts_user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.accounts_user_path(conn, :show, user)

      conn = get(conn, Routes.accounts_user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.accounts_user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.accounts_user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.accounts_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.accounts_user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
