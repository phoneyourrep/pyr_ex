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
end
