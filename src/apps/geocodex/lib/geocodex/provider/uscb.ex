defmodule Geocodex.Provider.USCB do
  @moduledoc """
  U.S. Census Bureau geocoding service.
  """

  use Geocodex.Provider,
    base_url: "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress",
    default_headers: [{"Accept", "application/json"}],
    default_params: [benchmark: "Public_AR_Current"]

  @doc false
  @impl Geocodex.Provider
  def coordinates(address) do
    {:ok, %{body: body}} = get("", [], params: [address: address])

    coordinates =
      body
      |> Jason.decode!()
      |> get_in(["result", "addressMatches", Access.at(0), "coordinates"])

    case coordinates do
      %{"x" => x, "y" => y} -> {:ok, %{x: x, y: y}}
      _ -> :error
    end
  end
end
