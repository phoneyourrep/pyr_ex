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

        jurisdiction =
          shape
          |> Map.drop([:geom])
          |> Map.put(:fips, shape.cd116fp)
          |> Map.put(:name, shape.namelsad)
          |> Map.put(:type, "us_cd")

        Jurisdiction.changeset(%Jurisdiction{}, jurisdiction)
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

        jurisdiction =
          shape
          |> Map.drop([:geom])
          |> Map.put(:fips, shape.statefp)
          |> Map.put(:type, "us_state")

        Jurisdiction.changeset(%Jurisdiction{}, jurisdiction)
        |> Repo.insert!()
      end)
    end)
  end)

[congress_tasks, states_tasks]
|> List.flatten()
|> Enum.each(fn task -> Task.await(task, :infinity) end)
