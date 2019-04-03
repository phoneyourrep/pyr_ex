defmodule PYREx.TestFixtures do
  @moduledoc """
  A module for defining fixtures that can be used in tests.
  This module can be used with a list of fixtures to apply as parameters:

      use PYREx.TestFixtures, [:user]

  """

  def user do
    alias PYREx.Accounts

    quote do
      @valid_attrs %{
        email: "some@email",
        intended_usage: "some intended_usage",
        name: "some name",
        organization: "some organization",
        website: "some website"
      }
      @update_attrs %{
        email: "some.updated@email",
        intended_usage: "some updated intended_usage",
        name: "some updated name",
        organization: "some updated organization",
        website: "some updated website",
        is_authorized: false
      }
      @invalid_attrs %{
        email: nil,
        intended_usage: nil,
        name: nil,
        organization: nil,
        website: nil
      }

      def user_fixture(attrs \\ %{}) do
        {:ok, user} =
          attrs
          |> Enum.into(@valid_attrs)
          |> Accounts.create_user()

        user
      end
    end
  end

  @doc """
  Apply the `fixtures`.
  """
  defmacro __using__(fixtures) when is_list(fixtures) do
    for fixture <- fixtures, is_atom(fixture), do: apply(__MODULE__, fixture, [])
  end
end
