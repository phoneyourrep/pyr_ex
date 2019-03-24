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
alias PYREx.Geographies.{Shape, Jurisdiction}
alias PYREx.Repo

## Jurisdictions and Shapes
shapefile_seed_data = YamlElixir.read_from_file!("apps/pyr_ex/priv/repo/shapefiles.yml")
shapefiles = shapefile_seed_data["shapefiles"]
url = shapefile_seed_data["base_url"]

congress_task =
  Task.async(fn ->
    shapefiles["congress"]
    |> Shapefile.map_download(url, timeout: :infinity, recv_timeout: :infinity)
    |> Enum.each(fn shape ->
      Shape.changeset(%Shape{}, shape)
      |> Repo.insert!()

      fips = shape.cd115fp
      shape = shape |> Map.put(:fips, fips) |> Map.put(:name, fips)
      Jurisdiction.changeset(%Jurisdiction{}, Map.put(shape, :type, "us_cd"))
      |> Repo.insert!()
    end)
  end)

states_task =
  Task.async(fn ->
    shapefiles["states"]
    |> Shapefile.map_download(url, timeout: :infinity, recv_timeout: :infinity)
    |> Enum.each(fn shape ->
      Shape.changeset(%Shape{}, shape)
      |> Repo.insert!()

      shape = Map.put(shape, :fips, shape.statefp)
      Jurisdiction.changeset(%Jurisdiction{}, Map.put(shape, :type, "us_state"))
      |> Repo.insert!()
    end)
  end)

Enum.each([congress_task, states_task], fn task -> Task.await(task, :infinity) end)
