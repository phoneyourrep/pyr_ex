defmodule PYREx.DistrictsTest do
  use PYREx.DataCase

  alias PYREx.Districts

  describe "shapes" do
    alias PYREx.Districts.Shape

    @geom1 %Geo.Point{coordinates: {1.0, 2.0}}
    @geom2 %Geo.Point{coordinates: {2.0, 2.0}}
    @valid_attrs %{geom: @geom1, identifier: "some identifier"}
    @update_attrs %{geom: @geom2, identifier: "some updated identifier"}
    @invalid_attrs %{geom: nil, identifier: nil}

    def shape_fixture(attrs \\ %{}) do
      {:ok, shape} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Districts.create_shape()

      shape
    end

    test "list_shapes/0 returns all shapes" do
      shape = shape_fixture()
      assert Districts.list_shapes() == [shape]
    end

    test "get_shape!/1 returns the shape with given id" do
      shape = shape_fixture()
      assert Districts.get_shape!(shape.id) == shape
    end

    test "create_shape/1 with valid data creates a shape" do
      assert {:ok, %Shape{} = shape} = Districts.create_shape(@valid_attrs)
      assert shape.geom == %Geo.Point{coordinates: {1.0, 2.0}}
      assert shape.identifier == "some identifier"
    end

    test "create_shape/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Districts.create_shape(@invalid_attrs)
    end

    test "update_shape/2 with valid data updates the shape" do
      shape = shape_fixture()
      assert {:ok, %Shape{} = shape} = Districts.update_shape(shape, @update_attrs)
      assert shape.geom == %Geo.Point{coordinates: {2.0, 2.0}}
      assert shape.identifier == "some updated identifier"
    end

    test "update_shape/2 with invalid data returns error changeset" do
      shape = shape_fixture()
      assert {:error, %Ecto.Changeset{}} = Districts.update_shape(shape, @invalid_attrs)
      assert shape == Districts.get_shape!(shape.id)
    end

    test "delete_shape/1 deletes the shape" do
      shape = shape_fixture()
      assert {:ok, %Shape{}} = Districts.delete_shape(shape)
      assert_raise Ecto.NoResultsError, fn -> Districts.get_shape!(shape.id) end
    end

    test "change_shape/1 returns a shape changeset" do
      shape = shape_fixture()
      assert %Ecto.Changeset{} = Districts.change_shape(shape)
    end
  end
end
