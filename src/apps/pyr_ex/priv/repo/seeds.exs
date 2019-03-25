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

##### Jurisdictions and Shapes #####
shapefiles = YamlElixir.read_from_file!("apps/pyr_ex/priv/repo/shapefiles.yml")
congress = shapefiles["congress"]
states = shapefiles["states"]
sldl = shapefiles["state_legislative_districts_lower"]
sldu = shapefiles["state_legislative_districts_upper"]

congress_tasks =
  Enum.map(congress["filenames"], fn filename ->
    fn ->
      filename
      |> Shapefile.map_download(congress["base_url"], timeout: :infinity, recv_timeout: :infinity)
      |> Enum.each(fn shape ->
        Shape.changeset(%Shape{}, shape)
        |> Repo.insert!()

        jurisdiction =
          shape
          |> Map.drop([:geom])
          |> Map.put(:name, shape.namelsad)
          |> Map.put(:type, "us_cd")

        Jurisdiction.changeset(%Jurisdiction{}, jurisdiction)
        |> Repo.insert!()
      end)
    end
  end)

states_tasks =
  Enum.map(states["filenames"], fn filename ->
    fn ->
      filename
      |> Shapefile.map_download(states["base_url"], timeout: :infinity, recv_timeout: :infinity)
      |> Enum.map(fn shape ->
        Shape.changeset(%Shape{}, shape)
        |> Repo.insert!()

        jurisdiction =
          shape
          |> Map.drop([:geom])
          |> Map.put(:type, "us_state")

        Jurisdiction.changeset(%Jurisdiction{}, jurisdiction)
        |> Repo.insert!()
      end)
    end
  end)

sldl_tasks =
  Enum.map(sldl["filenames"], fn filename ->
    fn ->
      filename
      |> Shapefile.map_download(sldl["base_url"], timeout: :infinity, recv_timeout: :infinity)
      |> Enum.each(fn shape ->
        Shape.changeset(%Shape{}, shape)
        |> Repo.insert!()

        jurisdiction =
          shape
          |> Map.drop([:geom])
          |> Map.put(:name, shape.namelsad)
          |> Map.put(:type, "us_sldl")

        Jurisdiction.changeset(%Jurisdiction{}, jurisdiction)
        |> Repo.insert!()
      end)
    end
  end)

sldu_tasks =
  Enum.map(sldu["filenames"], fn filename ->
    fn ->
      filename
      |> Shapefile.map_download(sldu["base_url"], timeout: :infinity, recv_timeout: :infinity)
      |> Enum.each(fn shape ->
        Shape.changeset(%Shape{}, shape)
        |> Repo.insert!()

        jurisdiction =
          shape
          |> Map.drop([:geom])
          |> Map.put(:name, shape.namelsad)
          |> Map.put(:type, "us_sldu")

        Jurisdiction.changeset(%Jurisdiction{}, jurisdiction)
        |> Repo.insert!()
      end)
    end
  end)

[congress_tasks, states_tasks, sldl_tasks, sldu_tasks]
|> List.flatten()
|> Enum.chunk_every(3)
|> Enum.map(fn chunk ->
  Enum.map(chunk, fn task -> Task.async(task) end)
  |> Enum.map(fn task -> Task.await(task, :infinity) end)
end)

##### End of Jurisdictions and Shapes #####
