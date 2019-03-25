defmodule PYRExWeb.Email do
  import Bamboo.Email
  alias PYREx.Accounts.User

  @doc """
  Builds an email for a newly registered API user.

  Accepts two parameters, a `PYREx.Accounts.User` struct and the
  API key.
  """
  @spec authentication_email(User.t(), any()) :: Bamboo.Email.t()
  def authentication_email(user = %User{}, key) do
    base_email()
    |> to(user.email)
    |> html_body(html(key))
    |> text_body(text(key))
  end

  @doc """
  The email address listed as the sender of application emails.
  """
  @spec sender() :: String.t()
  def sender, do: "phoneyourrep@gmail.com"

  defp base_email do
    new_email()
    |> from(sender())
    |> subject("Your Phone Your Rep API Key")
    |> put_header("Reply-To", "phoneyourrep@gmail.com")
  end

  defp html(key) do
    """
    Thank you for using the Phone Your Rep API. Here is your key:<br><br>

        <strong>#{key}</strong><br><br>

    Please store this somewhere safe and do not hardcode it into your application
    or check it into version control. Don't lose this key, we won't be able to show it
    to you again.<br><br>

    Sincerely,<br><br>

    The Phone Your Rep Team
    """
  end

  defp text(key) do
    """
    Thank you for using the Phone Your Rep API. Here is your key:

        #{key}

    Please store this somewhere safe and do not hardcode it into your application
    or check it into version control.

    Sincerely,

    The Phone Your Rep Team
    """
  end
end
