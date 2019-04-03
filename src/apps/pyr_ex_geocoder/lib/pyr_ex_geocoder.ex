defmodule PYRExGeocoder do
  @moduledoc """
  Documentation for PYRExGeocoder.
  """

  use HTTPoison.Base

  @base_url "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"
  @headers [{"Accept", "application/json"}]
  @params [benchmark: "Public_AR_Current"]

  @doc """
  Geocodes an address into x/y coordinates.

  ## Examples

      iex> PYRExGeocoder.coordinates("1600 Pennsylvania Ave NW, Washington, D.C., 20500")
      {:ok, %{x: -77.03535, y: 38.898754}}
  """
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

  @doc false
  def process_request_url(url) do
    @base_url <> url
  end

  @doc false
  def process_request_headers(headers) do
    @headers ++ headers
  end

  @doc false
  def process_request_options(options) do
    update_in(options, [:params], fn x -> Keyword.merge(x, @params) end)
  end
end
