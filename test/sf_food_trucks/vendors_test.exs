defmodule SFFoodTrucks.VendorsTest do
  use SFFoodTrucks.DataCase

  alias SFFoodTrucks.Vendors

  describe "vendors" do
    alias SFFoodTrucks.Vendors.Vendor

    import SFFoodTrucks.VendorsFixtures

    @invalid_attrs %{
      block: nil,
      name: nil,
      status: nil,
      type: nil,
      zip: nil,
      address: nil,
      permit: nil,
      location: nil,
      approved: nil,
      location_id: nil,
      cnn: nil,
      location_desc: nil,
      block_lot: nil,
      lot: nil,
      food_items: nil,
      x_coordinate: nil,
      y_coordinate: nil,
      latitude: nil,
      schedule: nil,
      days_hours: nil,
      received: nil,
      expiration_date: nil
    }

    test "list/0 returns all vendors" do
      vendor = vendor_fixture()
      assert Vendors.list() == [vendor]
    end

    test "get!/1 returns the vendor with given id" do
      vendor = vendor_fixture()
      assert Vendors.get!(vendor.id) == vendor
    end

    test "create/1 with valid data creates a vendor" do
      valid_attrs = %{
        block: 42,
        name: "some name",
        status: "some status",
        type: "some type",
        zip: 42,
        address: "some address",
        permit: "some permit",
        location: "some location",
        approved: ~U[2024-02-25 05:56:00Z],
        location_id: 42,
        cnn: 42,
        location_desc: "some location_desc",
        block_lot: 42,
        lot: 42,
        food_items: "some food_items",
        x_coordinate: 120.5,
        y_coordinate: 120.5,
        latitude: 120.5,
        schedule: "some schedule",
        days_hours: "some days_hours",
        received: ~U[2024-02-25 05:56:00Z],
        expiration_date: ~U[2024-02-25 05:56:00Z]
      }

      assert {:ok, %Vendor{} = vendor} = Vendors.create(valid_attrs)
      assert vendor.block == 42
      assert vendor.name == "some name"
      assert vendor.status == "some status"
      assert vendor.type == "some type"
      assert vendor.zip == 42
      assert vendor.address == "some address"
      assert vendor.permit == "some permit"
      assert vendor.location == "some location"
      assert vendor.approved == ~U[2024-02-25 05:56:00Z]
      assert vendor.location_id == 42
      assert vendor.cnn == 42
      assert vendor.location_desc == "some location_desc"
      assert vendor.block_lot == 42
      assert vendor.lot == 42
      assert vendor.food_items == "some food_items"
      assert vendor.x_coordinate == 120.5
      assert vendor.y_coordinate == 120.5
      assert vendor.latitude == 120.5
      assert vendor.schedule == "some schedule"
      assert vendor.days_hours == "some days_hours"
      assert vendor.received == ~U[2024-02-25 05:56:00Z]
      assert vendor.expiration_date == ~U[2024-02-25 05:56:00Z]
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vendors.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the vendor" do
      vendor = vendor_fixture()

      update_attrs = %{
        block: 43,
        name: "some updated name",
        status: "some updated status",
        type: "some updated type",
        zip: 43,
        address: "some updated address",
        permit: "some updated permit",
        location: "some updated location",
        approved: ~U[2024-02-26 05:56:00Z],
        location_id: 43,
        cnn: 43,
        location_desc: "some updated location_desc",
        block_lot: 43,
        lot: 43,
        food_items: "some updated food_items",
        x_coordinate: 456.7,
        y_coordinate: 456.7,
        latitude: 456.7,
        schedule: "some updated schedule",
        days_hours: "some updated days_hours",
        received: ~U[2024-02-26 05:56:00Z],
        expiration_date: ~U[2024-02-26 05:56:00Z]
      }

      assert {:ok, %Vendor{} = vendor} = Vendors.update(vendor, update_attrs)
      assert vendor.block == 43
      assert vendor.name == "some updated name"
      assert vendor.status == "some updated status"
      assert vendor.type == "some updated type"
      assert vendor.zip == 43
      assert vendor.address == "some updated address"
      assert vendor.permit == "some updated permit"
      assert vendor.location == "some updated location"
      assert vendor.approved == ~U[2024-02-26 05:56:00Z]
      assert vendor.location_id == 43
      assert vendor.cnn == 43
      assert vendor.location_desc == "some updated location_desc"
      assert vendor.block_lot == 43
      assert vendor.lot == 43
      assert vendor.food_items == "some updated food_items"
      assert vendor.x_coordinate == 456.7
      assert vendor.y_coordinate == 456.7
      assert vendor.latitude == 456.7
      assert vendor.schedule == "some updated schedule"
      assert vendor.days_hours == "some updated days_hours"
      assert vendor.received == ~U[2024-02-26 05:56:00Z]
      assert vendor.expiration_date == ~U[2024-02-26 05:56:00Z]
    end

    test "update/2 with invalid data returns error changeset" do
      vendor = vendor_fixture()
      assert {:error, %Ecto.Changeset{}} = Vendors.update(vendor, @invalid_attrs)
      assert vendor == Vendors.get!(vendor.id)
    end

    test "delete/1 deletes the vendor" do
      vendor = vendor_fixture()
      assert {:ok, %Vendor{}} = Vendors.delete(vendor)
      assert_raise Ecto.NoResultsError, fn -> Vendors.get!(vendor.id) end
    end

    test "change/1 returns a vendor changeset" do
      vendor = vendor_fixture()
      assert %Ecto.Changeset{} = Vendors.change(vendor)
    end
  end
end
