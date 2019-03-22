defmodule PYRExGeocoder do
  @moduledoc """
  Documentation for PYRExGeocoder.
  """

  @base_url "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"
  @headers [{"Accept", "application/json"}]
  @params [benchmark: "Public_AR_Current"]

  @doc """
  Geocodes an address into x/y coordinates.

  ## Examples

      iex> PYRExGeocoder.coordinates("1600 Pennsylvania Ave NW, Washington, D.C., 20500")
      %{"x" => -77.03535, "y" => 38.898754}
  """
  def coordinates(address) do
    params = Keyword.merge(@params, address: address)

    with {:ok, %{body: body}} <- HTTPoison.get(@base_url, @headers, params: params) do
      body
      |> Jason.decode!()
      |> get_in(["result", "addressMatches", Access.at(0), "coordinates"])
    end
  end
end
