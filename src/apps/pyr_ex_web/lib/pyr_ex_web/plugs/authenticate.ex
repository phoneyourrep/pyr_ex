defmodule PYRExWeb.Plugs.Authenticate do
  @moduledoc """
  Authenticates the requestor's API key.

  Checks the existence and value of the `"api_key"` query parameter
  and redirects connection based on authentication of the key.
  """
  import Plug.Conn
  import Phoenix.Controller, only: [render: 3, put_view: 2]
  alias PYRExWeb.Authenticator
  alias PYRExWeb.ErrorView

  @doc false
  def init(default), do: default

  @doc false
  def call(%Plug.Conn{params: %{"api_key" => key}} = conn, _default) do
    if Mix.env() == :dev && key == "dev" do
      conn
    else
      case Authenticator.verify(key) do
        {:ok, id} ->
          assign(conn, :user_id, id)

        {:error, :invalid} ->
          conn
          |> put_view(ErrorView)
          |> render("invalid_key.json", %{key: key})
          |> halt()
      end
    end
  end

  def call(conn, _default) do
    conn
    |> put_view(ErrorView)
    |> render("no_key.json", %{})
    |> halt()
  end
end
