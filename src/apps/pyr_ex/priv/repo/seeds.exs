# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PYREx.Repo.insert!(%PYREx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PYRExShapefile, as: Shapefile
alias PYREx.Districts.Shape
alias PYREx.Repo

shapefile_seed_data = YamlElixir.read_from_file!("apps/pyr_ex/priv/repo/shapefiles.yml")
shapefiles = shapefile_seed_data["shapefiles"]
url = shapefile_seed_data["base_url"]

Enum.map(shapefiles, fn shapefile ->
  Task.async(fn ->
    shapefile
    |> Shapefile.map_download(url, timeout: :infinity, recv_timeout: :infinity)
    |> Enum.each(fn shape ->
      Shape.changeset(%Shape{}, shape)
      |> Repo.insert!()
    end)
  end)
end)
|> Enum.each(fn task -> Task.await(task, :infinity) end)
