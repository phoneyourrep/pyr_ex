defmodule PYRExWeb.Router do
  use PYRExWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PYRExWeb do
    pipe_through :browser

    get "/", HomeController, :index
  end

  scope "/accounts", PYRExWeb.Accounts, as: :accounts do
    pipe_through :browser

    resources "/users", UserController
  end

  scope "/api", PYRExWeb do
    pipe_through :api

    resources "/jurisdictions", JurisdictionController, except: [:new, :edit]
  end
end
