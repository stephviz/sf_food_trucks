defmodule SFFoodTrucks.Repo.Migrations.UpdateVendorType do
  use Ecto.Migration

  def up do
    execute("UPDATE vendors SET type = 'Unknown' WHERE type IS NULL")
  end

  def down do
    execute("UPDATE vendors SET type = NULL WHERE type = 'Unknown'")
  end
end
