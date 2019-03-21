defmodule PYRExShapefile do
  @moduledoc """
  Read shapefile data.
  """

  @shp_dir "#{File.cwd!()}/shp"

  def shp(shapefile) do
    File.stream!("#{@shp_dir}/#{shapefile}/#{shapefile}.shp", [], 2048)
    |> Exshape.Shp.read()
  end

  def dbf(shapefile) do
    File.stream!("#{@shp_dir}/#{shapefile}/#{shapefile}.dbf", [], 2048)
    |> Exshape.Dbf.read()
  end

  @doc """
  Decodes data from a Zip archived shapefile.

  ## Example

      [{"cb_2017_us_cd115_5m", proj, shapes}] = PYRExShapefile.from_zip("cb_2017_us_cd115_5m")
      shapes |> Enum.take(1)
      #=> [{%Exshape.Shp.Header{...}, %Exshape.Dbf.Header{...}}]
  """
  def from_zip(shapefile) do
    [{_, _, shapes}] = Exshape.from_zip("#{@shp_dir}/#{shapefile}.zip")
    shapes
  end

  @doc """
  Parses unzipped shapefile data into maps.
  """
  def map_shapes(shapes) do
    [{_, dbf_header}] = Enum.take(shapes, 1)

    headers =
      dbf_header.columns
      |> Stream.map(fn column -> column.name end)
      |> Enum.with_index()

    {maps, _} =
      shapes
      |> Stream.drop(1)
      |> Enum.map_reduce(headers, fn {shp, dbf}, headers ->
        result =
          Enum.reduce(headers, %{geom: exshape_to_geo(shp)}, fn {attr, index}, map ->
            key = attr |> String.downcase() |> String.to_atom()
            Map.put(map, key, Enum.at(dbf, index))
          end)

        {result, headers}
      end)

    maps
  end

  @doc """
  Transforms an `Exshape.Shp.Polygon.t()` to a `Geo.Polygon.t()`.

  ## Examples

      iex> PYRExShapefile.exshape_to_geo(%Exshape.Shp.Polygon{points: [[[
      ...>   %Exshape.Shp.Point{x: -96.639704, y: 42.737071},
      ...>   %Exshape.Shp.Point{x: -96.635886, y: 42.741002},
      ...>   %Exshape.Shp.Point{x: -96.632314, y: 42.745641}
      ...> ]]]})
      %Geo.MultiPolygon{coordinates: [[[
        {42.737071, -96.639704},
        {42.741002, -96.635886},
        {42.745641, -96.632314}
      ]]], srid: 3857}
  """
  def exshape_to_geo(%Exshape.Shp.Polygon{points: polygons}) do
    coordinates =
      Enum.map(polygons, fn polygon ->
        Enum.map(polygon, fn points ->
          Enum.map(points, fn %{x: lon, y: lat} ->
            {lat, lon}
          end)
        end)
      end)

    %Geo.MultiPolygon{coordinates: coordinates, srid: srid()}
  end

  @doc """
  The SRID projection used by the application. Returns the integer value `3857`.

  ## Examples

      iex> PYRExShapefile.srid()
      3857
  """
  def srid, do: 3857
end
