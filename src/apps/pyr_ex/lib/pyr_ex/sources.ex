defmodule PYREx.Sources do
  @moduledoc """
  The sources for the PYREx database.

  Sources are fetched from a remote git repository and require an internet
  to return results.
  """

  @base_url "https://raw.githubusercontent.com/phoneyourrep/sources/master/"

  @doc """
  The url paths for shapefile data.
  """
  def shapefiles do
    {:ok, %{body: body, status_code: 200}} = HTTPoison.get(@base_url <> "shapefiles.yml")

    YamlElixir.read_from_string!(body)
  end
end
