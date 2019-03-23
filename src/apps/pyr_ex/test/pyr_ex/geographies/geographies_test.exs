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

  describe "jurisdictions" do
    alias PYREx.Geographies.Jurisdiction

    @valid_attrs %{fips: "some fips", geoid: "some geoid", name: "some name", statefp: "some statefp", type: "some type"}
    @update_attrs %{fips: "some updated fips", geoid: "some updated geoid", name: "some updated name", statefp: "some updated statefp", type: "some updated type"}
    @invalid_attrs %{fips: nil, geoid: nil, name: nil, statefp: nil, type: nil}

    def jurisdiction_fixture(attrs \\ %{}) do
      {:ok, jurisdiction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Geographies.create_jurisdiction()

      jurisdiction
    end

    test "list_jurisdictions/0 returns all jurisdictions" do
      jurisdiction = jurisdiction_fixture()
      assert Geographies.list_jurisdictions() == [jurisdiction]
    end

    test "get_jurisdiction!/1 returns the jurisdiction with given id" do
      jurisdiction = jurisdiction_fixture()
      assert Geographies.get_jurisdiction!(jurisdiction.id) == jurisdiction
    end

    test "create_jurisdiction/1 with valid data creates a jurisdiction" do
      assert {:ok, %Jurisdiction{} = jurisdiction} = Geographies.create_jurisdiction(@valid_attrs)
      assert jurisdiction.fips == "some fips"
      assert jurisdiction.geoid == "some geoid"
      assert jurisdiction.name == "some name"
      assert jurisdiction.statefp == "some statefp"
      assert jurisdiction.type == "some type"
    end

    test "create_jurisdiction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Geographies.create_jurisdiction(@invalid_attrs)
    end

    test "update_jurisdiction/2 with valid data updates the jurisdiction" do
      jurisdiction = jurisdiction_fixture()
      assert {:ok, %Jurisdiction{} = jurisdiction} = Geographies.update_jurisdiction(jurisdiction, @update_attrs)
      assert jurisdiction.fips == "some updated fips"
      assert jurisdiction.geoid == "some updated geoid"
      assert jurisdiction.name == "some updated name"
      assert jurisdiction.statefp == "some updated statefp"
      assert jurisdiction.type == "some updated type"
    end

    test "update_jurisdiction/2 with invalid data returns error changeset" do
      jurisdiction = jurisdiction_fixture()
      assert {:error, %Ecto.Changeset{}} = Geographies.update_jurisdiction(jurisdiction, @invalid_attrs)
      assert jurisdiction == Geographies.get_jurisdiction!(jurisdiction.id)
    end

    test "delete_jurisdiction/1 deletes the jurisdiction" do
      jurisdiction = jurisdiction_fixture()
      assert {:ok, %Jurisdiction{}} = Geographies.delete_jurisdiction(jurisdiction)
      assert_raise Ecto.NoResultsError, fn -> Geographies.get_jurisdiction!(jurisdiction.id) end
    end

    test "change_jurisdiction/1 returns a jurisdiction changeset" do
      jurisdiction = jurisdiction_fixture()
      assert %Ecto.Changeset{} = Geographies.change_jurisdiction(jurisdiction)
    end
  end
end
