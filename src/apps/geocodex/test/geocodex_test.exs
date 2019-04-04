defmodule GeocodexTest do
  use ExUnit.Case
  doctest Geocodex

  @address "1600 Pennsylvania Ave NW, Washington, D.C., 20500"
  @expected_coordinates %{x: -77.03535, y: 38.898754}

  test "geocodes an address" do
    assert Geocodex.coordinates(@address) == {:ok, @expected_coordinates}
  end
end
