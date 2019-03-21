defmodule PYREx.Districts do
  @moduledoc """
  The Districts context.
  """

  import Ecto.Query, warn: false
  import Geo.PostGIS
  alias PYREx.Repo

  alias PYREx.Districts.Shape

  @doc """
  Returns the list of shapes.

  ## Examples

      iex> list_shapes()
      [%Shape{}, ...]

  """
  def list_shapes do
    Repo.all(Shape)
  end

  @doc """
  Gets a single shape.

  Raises `Ecto.NoResultsError` if the Shape does not exist.

  ## Examples

      iex> get_shape!(123)
      %Shape{}

      iex> get_shape!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shape!(id), do: Repo.get!(Shape, id)

  @doc """
  Creates a shape.

  ## Examples

      iex> create_shape(%{field: value})
      {:ok, %Shape{}}

      iex> create_shape(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shape(attrs \\ %{}) do
    %Shape{}
    |> Shape.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shape.

  ## Examples

      iex> update_shape(shape, %{field: new_value})
      {:ok, %Shape{}}

      iex> update_shape(shape, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shape(%Shape{} = shape, attrs) do
    shape
    |> Shape.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Shape.

  ## Examples

      iex> delete_shape(shape)
      {:ok, %Shape{}}

      iex> delete_shape(shape)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shape(%Shape{} = shape) do
    Repo.delete(shape)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shape changes.

  ## Examples

      iex> change_shape(shape)
      %Ecto.Changeset{source: %Shape{}}

  """
  def change_shape(%Shape{} = shape) do
    Shape.changeset(shape, %{})
  end

  @doc """
  Returns a list of shapes that intersect the given geometry.

  Input can be a tuple containing two floats (lat and lon) or a Geo struct.
  """
  def intersecting_shapes(coordinates = {lat, lon}) when is_number(lat) and is_number(lon) do
    %Geo.Point{coordinates: coordinates, srid: PYRExShapefile.srid()}
    |> intersects_shapes()
  end

  def intersecting_shapes(geom) do
    query = from shape in Shape,
              where: st_intersects(shape.geom, ^geom)

    Repo.all(query)
  end
end
