defmodule SFFoodTrucks.Vendors.Vendor do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :location_id,
    :name,
    :type,
    :cnn,
    :location_desc,
    :address,
    :block_lot,
    :block,
    :lot,
    :permit,
    :status,
    :food_items,
    :x_coordinate,
    :y_coordinate,
    :latitude,
    :longitude,
    :schedule,
    :days_hours,
    :approved,
    :received,
    :expiration_date,
    :location,
    :zip
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "vendors" do
    field :block, :string
    field :name, :string
    field :status, Ecto.Enum, values: [:REQUESTED, :EXPIRED, :APPROVED, :SUSPEND, :ISSUED]
    field :type, :string
    field :zip, :integer
    field :address, :string
    field :permit, :string
    field :location, :string
    field :approved, :string
    field :location_id, :integer
    field :cnn, :integer
    field :location_desc, :string
    field :block_lot, :string
    field :lot, :string
    field :food_items, {:array, :string}
    field :x_coordinate, :float
    field :y_coordinate, :float
    field :latitude, :float
    field :longitude, :float
    field :schedule, :string
    field :days_hours, :string
    field :received, :string
    field :expiration_date, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vendor, attrs) do
    vendor
    |> cast(attrs, [
      :location_id,
      :name,
      :type,
      :cnn,
      :location_desc,
      :address,
      :block_lot,
      :block,
      :lot,
      :permit,
      :status,
      :food_items,
      :x_coordinate,
      :y_coordinate,
      :latitude,
      :longitude,
      :schedule,
      :days_hours,
      :approved,
      :received,
      :expiration_date,
      :location,
      :zip
    ])
    |> validate_required([:location_id, :name, :type])
    |> validate_inclusion(:type, ["Truck", "Push Cart", "Unknown"])
    |> unique_constraint(:location_id)
  end

  def cast(vendor, :fetch) do
    %{
      location_id: vendor["objectid"],
      name: vendor["applicant"],
      type: get_type(vendor["facilitytype"]),
      cnn: vendor["cnn"],
      location_desc: vendor["locationdescription"],
      address: vendor["address"],
      block_lot: vendor["blocklot"],
      block: vendor["block"],
      lot: vendor["lot"],
      permit: vendor["permit"],
      status: vendor["status"],
      food_items: get_food_items(vendor["fooditems"]),
      x_coordinate: vendor["x"],
      y_coordinate: vendor["y"],
      latitude: vendor["latitude"],
      longitude: vendor["longitude"],
      schedule: vendor["schedule"],
      days_hours: vendor["dayshours"],
      approved: vendor["approved"],
      received: vendor["received"],
      expiration_date: vendor["expirationdate"],
      location: "(#{vendor["latitude"]}, #{vendor["longitude"]})",
      zip: vendor["location_zip"]
    }
  end

  defp get_type(facility_type) when facility_type in ["Truck", "Push Cart", "Unknown"],
    do: facility_type

  defp get_type(_facility_type), do: "Unknown"

  defp get_food_items(nil), do: []

  defp get_food_items(food_items) do
    food_items
    |> String.split(":", trim: true)
    |> Enum.map(&String.trim/1)
  end
end
