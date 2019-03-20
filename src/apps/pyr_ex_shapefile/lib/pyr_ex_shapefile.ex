defmodule PYRExShapefile do
  @moduledoc """
  Read shapefile data.
  """
  @shp_dir "#{File.cwd!}/shp"

  def shp(shapefile) do
    File.stream!("#{@shp_dir}/#{shapefile}/#{shapefile}.shp", [], 2048)
    |> Exshape.Shp.read()
  end

  def dbf(shapefile) do
    File.stream!("#{@shp_dir}/#{shapefile}/#{shapefile}.dbf", [], 2048)
    |> Exshape.Dbf.read()
  end

  def from_zip(shapefile) do
    Exshape.from_zip("#{@shp_dir}/#{shapefile}.zip")
  end

  def exshape_to_geo(%Exshape.Shp.Polygon{points: [polygon]}) do
    coordinates = Enum.map(polygon, fn points ->
      Enum.map(points, fn %{x: lon, y: lat} ->
        {lat, lon}
      end)
    end)

    %Geo.Polygon{coordinates: polygon, srid: 4269}
  end
end