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
        block: "42",
        name: "some name",
        status: :ISSUED,
        type: "Truck",
        zip: 42119,
        address: "some address",
        permit: "15MFF-0000",
        location: "(111, -222)",
        approved: "03/16/2019 12:00:00 AM",
        location_id: 42,
        cnn: 424242,
        location_desc: "some location_desc",
        block_lot: "42",
        lot: "42",
        food_items: ["some", "food_items"],
        x_coordinate: 120.5,
        y_coordinate: 120.5,
        latitude: 111,
        longitude: -222,
        schedule: "some schedule",
        days_hours: "Mo-We:7AM-7PM",
        received: "20160908",
        expiration_date: "03/15/2029 12:00:00 AM"
      }

      assert {:ok, %Vendor{} = vendor} = Vendors.create(valid_attrs)
      assert vendor.block == "42"
      assert vendor.name == "some name"
      assert vendor.status == :ISSUED
      assert vendor.type == "Truck"
      assert vendor.zip == 42119
      assert vendor.address == "some address"
      assert vendor.permit == "15MFF-0000"
      assert vendor.location == "(111, -222)"
      assert vendor.approved == "03/16/2019 12:00:00 AM"
      assert vendor.location_id == 42
      assert vendor.cnn == 424242
      assert vendor.location_desc == "some location_desc"
      assert vendor.block_lot == "42"
      assert vendor.lot == "42"
      assert vendor.food_items == ["some", "food_items"]
      assert vendor.x_coordinate == 120.5
      assert vendor.y_coordinate == 120.5
      assert vendor.latitude == 111
      assert vendor.longitude == -222
      assert vendor.schedule == "some schedule"
      assert vendor.days_hours == "Mo-We:7AM-7PM"
      assert vendor.received == "20160908"
      assert vendor.expiration_date == "03/15/2029 12:00:00 AM"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vendors.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the vendor" do
      vendor = vendor_fixture()

      update_attrs = %{
        block: "43",
        name: "some updated name",
        status: :APPROVED,
        type: "Unknown",
        zip: 434343,
        address: "some updated address",
        permit: "some updated permit",
        location: "some updated location",
        approved: "09/16/2017 12:00:00 AM",
        location_id: 43,
        cnn: 44433333,
        location_desc: "some updated location_desc",
        block_lot: "43",
        lot: "43",
        food_items: ["some", "updated", "food_items"],
        x_coordinate: 456.7,
        y_coordinate: 456.7,
        latitude: 333.7,
        longitude: -444,
        schedule: "some updated schedule",
        days_hours: "some updated days_hours",
        received: "20150401",
        expiration_date: "09/16/2027 12:00:00 AM"
      }

      assert {:ok, %Vendor{} = vendor} = Vendors.update(vendor, update_attrs)
      assert vendor.block == "43"
      assert vendor.name == "some updated name"
      assert vendor.status == :APPROVED
      assert vendor.type == "Unknown"
      assert vendor.zip == 434343
      assert vendor.address == "some updated address"
      assert vendor.permit == "some updated permit"
      assert vendor.location == "some updated location"
      assert vendor.approved == "09/16/2017 12:00:00 AM"
      assert vendor.location_id == 43
      assert vendor.cnn == 44433333
      assert vendor.location_desc == "some updated location_desc"
      assert vendor.block_lot == "43"
      assert vendor.lot == "43"
      assert vendor.food_items == ["some", "updated", "food_items"]
      assert vendor.x_coordinate == 456.7
      assert vendor.y_coordinate == 456.7
      assert vendor.latitude == 333.7
      assert vendor.longitude == -444
      assert vendor.schedule == "some updated schedule"
      assert vendor.days_hours == "some updated days_hours"
      assert vendor.received == "20150401"
      assert vendor.expiration_date == "09/16/2027 12:00:00 AM"
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
