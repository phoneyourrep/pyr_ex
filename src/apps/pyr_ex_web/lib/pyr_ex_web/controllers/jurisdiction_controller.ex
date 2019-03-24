defmodule PYRExWeb.JurisdictionController do
  use PYRExWeb, :controller

  alias PYREx.Geographies

  plug PYRExWeb.Plugs.Authenticate

  action_fallback PYRExWeb.FallbackController

  def index(conn, %{"address" => address}) do
    jurisdictions = Geographies.intersecting_jurisdictions(address)
    do_index(conn, jurisdictions)
  end

  def index(conn, %{"lat" => lat, "lon" => lon}) do
    jurisdictions = Geographies.intersecting_jurisdictions({lat, lon})
    do_index(conn, jurisdictions)
  end

  def index(conn, _params) do
    jurisdictions = Geographies.list_jurisdictions()
    do_index(conn, jurisdictions)
  end

  def do_index(conn, jurisdictions) do
    render(conn, "index.json", jurisdictions: jurisdictions)
  end

  def show(conn, %{"id" => id}) do
    jurisdiction = Geographies.get_jurisdiction!(id)
    render(conn, "show.json", jurisdiction: jurisdiction)
  end
end
