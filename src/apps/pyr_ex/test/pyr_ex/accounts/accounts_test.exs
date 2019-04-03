defmodule PYREx.AccountsTest do
  use PYREx.DataCase
  use PYREx.TestFixtures, [:user]

  alias PYREx.Accounts

  describe "users" do
    alias PYREx.Accounts.User

    test "list_users/0 returns all users" do
      user = user_fixture(%{is_authorized: true})
      assert Accounts.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture(%{is_authorized: true})
      assert Accounts.get_user(user.id) == user
      assert Accounts.get_user(1_000_000) == nil
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture(%{is_authorized: true})
      assert Accounts.get_user!(user.id) == user
      assert_raise(Ecto.NoResultsError, fn -> Accounts.get_user!(1_000_000) end)
    end

    test "get_user_by_email/1 returns the user with the given email" do
      user = user_fixture(%{is_authorized: true})
      assert Accounts.get_user_by_email(user.email) == user
      assert Accounts.get_user_by_email("wrong@one") == nil
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email"
      assert user.intended_usage == "some intended_usage"
      assert user.name == "some name"
      assert user.organization == "some organization"
      assert user.website == "some website"
    end

    test "create_user/1 with blank :is_authorized autopopulates with true" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      refute user.is_authorized == true
      user = Accounts.get_user!(user.id)
      assert user.is_authorized == true
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some.updated@email"
      assert user.intended_usage == "some updated intended_usage"
      assert user.name == "some updated name"
      assert user.organization == "some updated organization"
      assert user.website == "some updated website"
      assert user.is_authorized == false
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture(%{is_authorized: true})
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
