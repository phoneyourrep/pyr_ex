defmodule PYRExWeb.EmailTest do
  use ExUnit.Case
  alias PYREx.Accounts.User
  alias PYRExWeb.Email

  setup do
    user = %User{
      email: "some email",
      intended_usage: "some intended_usage",
      name: "some name",
      organization: "some organization",
      website: "some website",
      id: 12
    }

    key = PYRExWeb.Authenticator.generate_key(user)

    %{user: user, key: key}
  end

  test "authentication email", %{user: user, key: key} do
    email = Email.authentication_email(user, key)

    assert email.to == user.email
    assert email.from == Email.sender()
    assert email.subject == "Your Phone Your Rep API Key"
    assert email.html_body =~ key
  end
end
