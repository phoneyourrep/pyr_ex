defmodule PYRExWeb.AuthenticatorTest do
  use ExUnit.Case, async: true
  doctest PYRExWeb.Authenticator

  describe "API keys" do
    alias PYRExWeb.Authenticator
    alias PYREx.Accounts.User

    setup do
      %{user: %User{id: 34}}
    end

    test "generates an API key", %{user: user} do
      key = Authenticator.generate_key(user)
      assert is_binary(key) == true
    end

    test "verifies an API key", %{user: user} do
      key = Authenticator.generate_key(user)
      assert {:ok, id} = Authenticator.verify(key)
      assert id == user.id
    end
  end
end
