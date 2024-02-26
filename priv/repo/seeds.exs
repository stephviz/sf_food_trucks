# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
NimbleCSV.define(VendorParser, separator: ",", escape: "\"")

"priv/repo/seed_files/vendors_seed.csv"
|> File.stream!()
|> VendorParser.parse_stream()
|> Stream.each(fn [
                    location_id,
                    applicant,
                    facility_type,
                    cnn,
                    location_description,
                    address,
                    blocklot,
                    block,
                    lot,
                    permit,
                    status,
                    items_offered,
                    x,
                    y,
                    latitude,
                    longitude,
                    schedule,
                    days_hours,
                    _noi_sent,
                    approved,
                    received,
                    _prior_permit,
                    expiration_date,
                    location,
                    _fire_prevention_districts,
                    _police_districts,
                    _supervisor_districts,
                    zip_codes,
                    _neighborhoods
                  ] ->
  food_items =
    items_offered
    |> String.split(":", trim: true)
    |> Enum.map(&String.trim(&1))

  %{
    location_id: location_id,
    name: applicant,
    type: facility_type,
    cnn: cnn,
    location_desc: location_description,
    address: address,
    block_lot: blocklot,
    block: block,
    lot: lot,
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
    received: received,
    expiration_date: expiration_date,
    location: location,
    zip: zip_codes
  }
  |> SfFoodTrucks.Vendors.create()
end)
|> Stream.run()
