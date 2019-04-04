defmodule PYREx.Shapefile do
  @moduledoc """
  Read shapefile data.
  """

  def shp(shapefile) do
    File.stream!(shapefile, [], 2048)
    |> Exshape.Shp.read()
  end

  def dbf(shapefile) do
    File.stream!(shapefile, [], 2048)
    |> Exshape.Dbf.read()
  end

  @doc """
  Downloads the given shapefile from the U.S. Census Bureau and maps the data
  for database insertion. The file is not saved to the file system.
  """
  def map_download(filename, base_url, opts \\ []) do
    url = "#{base_url}/#{filename}"
    shapefile = System.tmp_dir!() <> filename
    opts = Keyword.merge(opts, follow_redirect: true, max_redirects: 1)
    File.write!(shapefile, HTTPoison.get!(url, [], opts).body)

    # TODO: Handle failure in the case of server responses like the following:
    # <HTML><HEAD>
    # <TITLE>Service Unavailable</TITLE>
    # </HEAD><BODY>
    # <H1>Service Unavailable - DNS failure</H1>
    # The server is temporarily unable to service your request.  Please try again
    # later.<P>
    # Reference&#32;&#35;11&#46;71896783&#46;1554355711&#46;3a7ff4f
    # </BODY></HTML>

    shapes =
      shapefile
      |> from_zip()
      |> map_shapes()

    File.rm!(shapefile)

    shapes
  end

  @doc """
  Decodes data from a Zip archived shapefile in the current working directory.
  """
  def from_zip(shapefile) do
    [{_, _, shapes}] = Exshape.from_zip(shapefile)
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
            key =
              attr
              |> String.downcase()
              |> String.to_atom()

            val =
              case is_binary(x = Enum.at(dbf, index)) do
                true -> String.trim(x)
                false -> x
              end

            Map.put(map, key, val)
          end)

        {result, headers}
      end)

    maps
  end

  @doc """
  Transforms an `Exshape.Shp.Polygon.t()` to a `Geo.Polygon.t()`.

  ## Examples

      iex> PYREx.Shapefile.exshape_to_geo(%Exshape.Shp.Polygon{points: [[[
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

      iex> PYREx.Shapefile.srid()
      3857
  """
  def srid, do: 3857
end
