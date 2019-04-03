defmodule PYREx.Accounts.User do
  @moduledoc """
  API user. Users must register to receive a key for API access.

  Data fields:

    * `:email` - String. Must be unique. Validations will fail if the record already exists
    in the database.
    * `:name` - String.
    * `:organization` - String.
    * `:website` - String.
    * `:intended_usage` - String. Longer form explanation of how the API will be used.
    * `:authorized` - Boolean. Is the user associated with the email address authorized to
    use the API? Authorization may be suspended for misuse.

  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :intended_usage, :string
    field :name, :string
    field :organization, :string
    field :website, :string
    field :is_authorized, :boolean

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :website, :organization, :intended_usage, :is_authorized])
    |> validate_required([:email, :name, :website, :organization, :intended_usage])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc """
  Returns true if a user is authorized, false if they are not.

  ## Examples

      iex> authorized?(%User{is_authorized: true})
      true

      iex> authorized?(%User{is_authorized: false})
      false

  """
  def authorized?(user = %__MODULE__{}), do: user.is_authorized
end
