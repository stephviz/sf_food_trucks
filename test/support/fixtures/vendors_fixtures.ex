defmodule SFFoodTrucks.VendorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SFFoodTrucks.Vendors` context.
  """

  @doc """
  Generate a vendor.
  """
  def vendor_fixture(attrs \\ %{}) do
    {:ok, vendor} =
      attrs
      |> Enum.into(%{
        address: "some address",
        block: "42",
        block_lot: "42",
        cnn: 42,
        days_hours: "some days_hours",
        expiration_date: "03/15/2016 12:00:00 AM",
        food_items: ["some", "food_items"],
        latitude: 120.5,
        location: "some location",
        location_desc: "some location_desc",
        location_id: 42,
        lot: "42",
        name: "some name",
        permit: "some permit",
        received: "20151231",
        schedule: "some schedule",
        status: :ISSUED,
        type: "Truck",
        x_coordinate: 120.5,
        y_coordinate: 120.5,
        zip: 42119
      })
      |> SFFoodTrucks.Vendors.create()

    vendor
  end

  @doc """
  Generate multiple vendors.
  """
  def multi_vendor_fixture(attrs \\ %{}) do
    Enum.map(1..3, fn _ -> vendor_fixture(attrs) end)
  end
end
