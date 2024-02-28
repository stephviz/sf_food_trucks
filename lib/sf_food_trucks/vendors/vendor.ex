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
    field :status, :string
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
      :schedule,
      :days_hours,
      :approved,
      :received,
      :expiration_date,
      :location,
      :zip
    ])
  end
end
