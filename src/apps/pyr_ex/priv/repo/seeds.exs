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

Shapefile.from_zip("cb_2017_us_cd115_5m")
|> Shapefile.map_shapes()
|> Enum.each(fn shape ->
  Shape.changeset(%Shape{}, shape)
  |> Repo.insert!()
end)
