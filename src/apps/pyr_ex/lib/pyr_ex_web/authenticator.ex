defmodule PYRExWeb.Authenticator do
  @moduledoc """
  Generate and verify API keys.
  """

  alias PYRExWeb.Endpoint
  alias PYREx.Accounts.User
  @salt "pyr_ex user authentication"

  @doc """
  Generates an API key for a user.

  ## Examples

      iex> user = %PYREx.Accounts.User{id: 34}
      iex> key = PYRExWeb.Authenticator.generate_key(user)
      iex> is_binary(key)
      true
  """
  def generate_key(user = %User{}), do: generate_key(user.id)

  def generate_key(id) when is_integer(id) do
    Phoenix.Token.sign(Endpoint, @salt, id)
  end

  @doc """
  Verifies an API key.

  ## Examples

      iex> user = %PYREx.Accounts.User{id: 34}
      iex> key = PYRExWeb.Authenticator.generate_key(user)
      iex> PYRExWeb.Authenticator.verify(key)
      {:ok, 34}
  """
  def verify(key, opts \\ []) do
    opts = Keyword.merge([max_age: :infinity], opts)
    Phoenix.Token.verify(Endpoint, @salt, key, opts)
  end
end
