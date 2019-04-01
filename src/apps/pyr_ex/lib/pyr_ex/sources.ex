defmodule PYREx.Sources do
  @moduledoc """
  The sources for the PYREx database.

  Sources are fetched from a remote git repository and require an internet
  connection to return results.
  """

  @base_url "https://raw.githubusercontent.com/phoneyourrep/sources/master/"

  @doc """
  Get a list of sources from the remote repo.
  """
  def get(resource) do
    {:ok, %{body: body, status_code: 200}} = HTTPoison.get(@base_url <> resource)

    YamlElixir.read_from_string!(body)
  end

  @doc """
  The url paths for shapefile data.
  """
  def shapefiles, do: get("shapefiles.yml")
end
