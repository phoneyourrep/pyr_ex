defmodule PYREx.GeographiesTest do
  use PYREx.DataCase

  alias PYREx.Geographies

  describe "shapes" do
    alias PYREx.Geographies.Shape

    @geom1 %Geo.Point{coordinates: {1.0, 2.0}}
    @geom2 %Geo.Point{coordinates: {2.0, 2.0}}
    @valid_attrs %{geom: @geom1, geoid: "some geoid"}
    @update_attrs %{geom: @geom2, geoid: "updated geoid"}
    @invalid_attrs %{geom: nil, geoid: nil}

    def shape_fixture(attrs \\ %{}) do
      {:ok, shape} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Geographies.create_shape()

      shape
    end

    test "list_shapes/0 returns all shapes" do
      shape = shape_fixture()
      assert Geographies.list_shapes() == [shape]
    end

    test "get_shape!/1 returns the shape with given id" do
      shape = shape_fixture()
      assert Geographies.get_shape!(shape.id) == shape
    end

    test "create_shape/1 with valid data creates a shape" do
      assert {:ok, %Shape{} = shape} = Geographies.create_shape(@valid_attrs)
      assert shape.geom == %Geo.Point{coordinates: {1.0, 2.0}}
      assert shape.geoid == "some geoid"
    end

    test "create_shape/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Geographies.create_shape(@invalid_attrs)
    end

    test "update_shape/2 with valid data updates the shape" do
      shape = shape_fixture()
      assert {:ok, %Shape{} = shape} = Geographies.update_shape(shape, @update_attrs)
      assert shape.geom == %Geo.Point{coordinates: {2.0, 2.0}}
      assert shape.geoid == "updated geoid"
    end

    test "update_shape/2 with invalid data returns error changeset" do
      shape = shape_fixture()
      assert {:error, %Ecto.Changeset{}} = Geographies.update_shape(shape, @invalid_attrs)
      assert shape == Geographies.get_shape!(shape.id)
    end

    test "delete_shape/1 deletes the shape" do
      shape = shape_fixture()
      assert {:ok, %Shape{}} = Geographies.delete_shape(shape)
      assert_raise Ecto.NoResultsError, fn -> Geographies.get_shape!(shape.id) end
    end

    test "change_shape/1 returns a shape changeset" do
      shape = shape_fixture()
      assert %Ecto.Changeset{} = Geographies.change_shape(shape)
    end
  end
end
