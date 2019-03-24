defmodule PYRExWeb.JurisdictionController do
  use PYRExWeb, :controller

  alias PYREx.Geographies
  alias PYREx.Geographies.Jurisdiction

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

  def create(conn, %{"jurisdiction" => jurisdiction_params}) do
    with {:ok, %Jurisdiction{} = jurisdiction} <- Geographies.create_jurisdiction(jurisdiction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.jurisdiction_path(conn, :show, jurisdiction))
      |> render("show.json", jurisdiction: jurisdiction)
    end
  end

  def show(conn, %{"id" => id}) do
    jurisdiction = Geographies.get_jurisdiction!(id)
    render(conn, "show.json", jurisdiction: jurisdiction)
  end

  def update(conn, %{"id" => id, "jurisdiction" => jurisdiction_params}) do
    jurisdiction = Geographies.get_jurisdiction!(id)

    with {:ok, %Jurisdiction{} = jurisdiction} <- Geographies.update_jurisdiction(jurisdiction, jurisdiction_params) do
      render(conn, "show.json", jurisdiction: jurisdiction)
    end
  end

  def delete(conn, %{"id" => id}) do
    jurisdiction = Geographies.get_jurisdiction!(id)

    with {:ok, %Jurisdiction{}} <- Geographies.delete_jurisdiction(jurisdiction) do
      send_resp(conn, :no_content, "")
    end
  end
end
