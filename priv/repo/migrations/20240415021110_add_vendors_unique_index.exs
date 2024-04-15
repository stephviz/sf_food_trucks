defmodule SFFoodTrucks.Repo.Migrations.AddVendorsUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:vendors, [:location_id])
  end
end
