defmodule SFFoodTrucks.Workers.FetchVendorsWorkerTest do
  use ExUnit.Case, async: true
  use SFFoodTrucks.DataCase

  import SFFoodTrucks.VendorsFixtures

  alias SFFoodTrucks.Workers.FetchVendorsWorker
  alias SFFoodTrucks.Vendors

  setup do
    vendor_fixture()

    on_exit(fn ->
      Application.put_env(
        :sf_food_trucks,
        :fetch_vendor_url,
        "https://data.sfgov.org/api/odata/v4/rqzj-sfat"
      )
    end)
  end

  describe "perform/1" do
    test "performs vendors fetch" do
      assert {:ok,
              %{
                records_processed: _records_processed,
                records_created: _records_created
              }} = FetchVendorsWorker.perform(%Oban.Job{})

      assert Vendors.list() |> length > 1
    end

    test "error on vendors fetch" do
      Application.put_env(
        :sf_food_trucks,
        :fetch_vendor_url,
        "https://data.sfgov.org/api/odata/v4/dummy-url"
      )

      assert {:error, %Oban.Job{}} = FetchVendorsWorker.perform(%Oban.Job{})
      assert Vendors.list() |> length == 1
    end
  end
end
