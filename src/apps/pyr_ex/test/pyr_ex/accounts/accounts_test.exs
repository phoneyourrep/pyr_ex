defmodule PYREx.AccountsTest do
  use PYREx.DataCase

  alias PYREx.Accounts

  describe "users" do
    alias PYREx.Accounts.User

    @valid_attrs %{email: "some email", intended_usage: "some intended_usage", name: "some name", organization: "some organization", website: "some website"}
    @update_attrs %{email: "some updated email", intended_usage: "some updated intended_usage", name: "some updated name", organization: "some updated organization", website: "some updated website"}
    @invalid_attrs %{email: nil, intended_usage: nil, name: nil, organization: nil, website: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.intended_usage == "some intended_usage"
      assert user.name == "some name"
      assert user.organization == "some organization"
      assert user.website == "some website"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.intended_usage == "some updated intended_usage"
      assert user.name == "some updated name"
      assert user.organization == "some updated organization"
      assert user.website == "some updated website"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end