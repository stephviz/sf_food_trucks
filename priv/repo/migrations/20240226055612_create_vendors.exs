defmodule SfFoodTrucks.Repo.Migrations.CreateVendors do
  use Ecto.Migration

  def change do
    create table(:vendors) do
      add :location_id, :integer
      add :name, :string
      add :type, :string
      add :cnn, :integer
      add :location_desc, :string
      add :address, :string
      add :block_lot, :string
      add :block, :string
      add :lot, :string
      add :permit, :string
      add :status, :string
      add :food_items, {:array, :string}, null: false, default: []
      add :x_coordinate, :float
      add :y_coordinate, :float
      add :latitude, :float
      add :longitude, :float
      add :schedule, :string
      add :days_hours, :string
      add :approved, :string
      add :received, :string
      add :expiration_date, :string
      add :location, :string
      add :zip, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
