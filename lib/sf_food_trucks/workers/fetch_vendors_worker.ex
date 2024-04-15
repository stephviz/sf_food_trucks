defmodule SFFoodTrucks.Workers.FetchVendorsWorker do
  use Oban.Worker
  # use Oban.Worker, queue: :scheduled, max_attempts: 10
  alias SFFoodTrucks.Vendors
  alias SFFoodTrucks.Vendors.Vendor

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args} = job) do
    url = Application.get_env(:sf_food_trucks, :fetch_vendor_url)

    case Req.get!(url) do
      res when res.status == 200 ->
        before_len = Vendors.list() |> length()

        records_processed =
          res.body["value"]
          |> Enum.map(fn vendor ->
            vendor
            |> Vendor.cast(:fetch)
            |> Vendors.create()
          end)
          |> length()

        after_len = Vendors.list() |> length()

        result = %{
          records_processed: records_processed,
          records_created: after_len - before_len
        }

        Phoenix.PubSub.broadcast(
          SFFoodTrucks.PubSub,
          "fetch_vendors",
          {:fetch_vendors_success, result}
        )

        {:ok, result}

      _ ->
        Phoenix.PubSub.broadcast(
          SFFoodTrucks.PubSub,
          "fetch_vendors",
          {:fetch_vendors_error, job}
        )

        {:error, job}
    end
  end
end
