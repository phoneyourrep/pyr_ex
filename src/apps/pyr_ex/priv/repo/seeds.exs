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
shapefiles = YamlElixir.read_from_file!("apps/pyr_ex/priv/repo/shapefiles.yml")
congress = shapefiles["congress"]
states = shapefiles["states"]

congress_tasks =
  Enum.map(congress["filenames"], fn filename ->
    Task.async(fn ->
      filename
      |> Shapefile.map_download(congress["base_url"], timeout: :infinity, recv_timeout: :infinity)
      |> Enum.each(fn shape ->
        Shape.changeset(%Shape{}, shape)
        |> Repo.insert!()

        fips = shape.cd116fp
        shape = shape |> Map.put(:fips, fips) |> Map.put(:name, fips)

        Jurisdiction.changeset(%Jurisdiction{}, Map.put(shape, :type, "us_cd"))
        |> Repo.insert!()
      end)
    end)
  end)

states_tasks =
  Enum.map(states["filenames"], fn filename ->
    Task.async(fn ->
      filename
      |> Shapefile.map_download(states["base_url"], timeout: :infinity, recv_timeout: :infinity)
      |> Enum.each(fn shape ->
        Shape.changeset(%Shape{}, shape)
        |> Repo.insert!()

        shape = Map.put(shape, :fips, shape.statefp)

        Jurisdiction.changeset(%Jurisdiction{}, Map.put(shape, :type, "us_state"))
        |> Repo.insert!()
      end)
    end)
  end)

[congress_tasks, states_tasks]
|> List.flatten()
|> Enum.each(fn task -> Task.await(task, :infinity) end)
