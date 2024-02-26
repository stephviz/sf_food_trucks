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
        approved: ~U[2024-02-25 05:56:00Z],
        block: 42,
        block_lot: 42,
        cnn: 42,
        days_hours: "some days_hours",
        expiration_date: ~U[2024-02-25 05:56:00Z],
        food_items: "some food_items",
        latitude: 120.5,
        location: "some location",
        location_desc: "some location_desc",
        location_id: 42,
        lot: 42,
        name: "some name",
        permit: "some permit",
        received: ~U[2024-02-25 05:56:00Z],
        schedule: "some schedule",
        status: "some status",
        type: "some type",
        x_coordinate: 120.5,
        y_coordinate: 120.5,
        zip: 42
      })
      |> SFFoodTrucks.Vendors.create()

    vendor
  end
end
