defmodule PYRExWeb.JurisdictionView do
  use PYRExWeb, :view
  alias PYRExWeb.JurisdictionView

  def render("index.json", %{jurisdictions: jurisdictions}) do
    %{data: render_many(jurisdictions, JurisdictionView, "jurisdiction.json")}
  end

  def render("show.json", %{jurisdiction: jurisdiction}) do
    %{data: render_one(jurisdiction, JurisdictionView, "jurisdiction.json")}
  end

  def render("jurisdiction.json", %{jurisdiction: jurisdiction}) do
    %{
      id: jurisdiction.id,
      type: jurisdiction.type,
      name: jurisdiction.name,
      geoid: jurisdiction.geoid,
      statefp: jurisdiction.statefp,
      mtfcc: jurisdiction.mtfcc,
      pyrgeoid: jurisdiction.pyrgeoid
    }
  end
end
