defmodule PYRExWeb.Router do
  use PYRExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PYRExWeb do
    pipe_through :api
  end
end
