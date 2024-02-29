defmodule SFFoodTrucks.MessageQueues.MessageHandler do
  @moduledoc """
  Saved messages to the DB
  """

  alias SFFoodTrucks.Vendors

  require Logger

  def handle_message(contents) do
    Enum.reduce_while(contents, {:ok, "done"}, fn c, _result ->
      case do_handle_message(c) do
        {:ok, vendor} -> {:cont, {:ok, vendor}}
        error -> {:halt, error}
      end
    end)
  end

  @spec do_handle_message(map(), map()) ::
          {:ok, Ecto.Schema.t()}
          | {:error, Ecto.Changeset.t()}
          | {:ignored, :unsupported}
          | no_return()
  def do_handle_message(%{"key" => _key, "value" => value}, headers) do
    do_handle_message(value, headers)
  end

  def do_handle_message(%{
        "Address" => address,
        "Applicant" => applicant,
        "Approved" => approved,
        "ExpirationDate" => expiration_date,
        "FacilityType" => facility_type,
        "Fire Prevention Districts" => _fire_prevention_districts,
        "FoodItems" => items_offered,
        "Latitude" => latitude,
        "Longitude" => longitude,
        "Location" => location,
        "LocationDescription" => location_description,
        "NOISent" => _noi_sent,
        "Neighborhoods (old)" => _,
        "Police Districts" => _police_districts,
        "PriorPermit" => _prior_permit,
        "Received" => received,
        "Schedule" => schedule,
        "Status" => status,
        "Supervisor Districts" => _supervisor_districts,
        "X" => x,
        "Y" => y,
        "Zip Codes" => zip_codes,
        "block" => block,
        "blocklot" => blocklot,
        "cnn" => cnn,
        "dayshours" => days_hours,
        "locationid" => location_id,
        "lot" => lot,
        "permit" => permit
      }) do
    IO.puts("RIGHT HERE - made it to create!")

    food_items =
      items_offered
      |> String.split(":", trim: true)
      |> Enum.map(&String.trim(&1))

    Vendors.create(%{
      location_id: location_id,
      name: applicant,
      type: facility_type,
      cnn: cnn,
      location_desc: location_description,
      address: address,
      block_lot: assure_binary(blocklot),
      block: assure_binary(block),
      lot: assure_binary(lot),
      permit: permit,
      status: status,
      food_items: food_items,
      x_coordinate: x,
      y_coordinate: y,
      latitude: latitude,
      longitude: longitude,
      schedule: schedule,
      days_hours: days_hours,
      approved: approved,
      received: assure_binary(received),
      expiration_date: expiration_date,
      location: location,
      zip: zip_codes
    })
    |> IO.inspect(label: "RIGHT HERE - create res")
    |> case do
      {:ok, vendor} ->
        {:ok, vendor}

      {:error, changeset} ->
        Logger.error("Could not insert vendor #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  def do_handle_message(hmm) do
    IO.inspect(hmm, label: "RIGHT HERE - hmm - something went wrong")
  end

  defp assure_binary(value) when is_binary(value), do: value
  defp assure_binary(value) when is_integer(value), do: Integer.to_string(value)
end
