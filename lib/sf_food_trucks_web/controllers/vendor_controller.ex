defmodule SFFoodTrucksWeb.VendorController do
  use SFFoodTrucksWeb, :controller

  alias SFFoodTrucks.Vendors
  alias SFFoodTrucks.Vendors.Vendor

  action_fallback SFFoodTrucksWeb.FallbackController

  def index(conn, _params) do
    vendors = Vendors.list()
    json(conn, %{data: vendors})
  end

  def create(conn, %{"vendor" => vendor_params}) do
    with {:ok, %Vendor{} = vendor} <- Vendors.create(vendor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/vendors/#{vendor}")
      |> json(%{data: vendor})
    end
  end

  def show(conn, %{"id" => id}) do
    vendor = Vendors.get!(id)
    json(conn, %{data: vendor})
  end

  def update(conn, %{"id" => id, "params" => vendor_params}) do
    vendor = Vendors.get!(id)

    with {:ok, %Vendor{} = vendor} <- Vendors.update(vendor, vendor_params) do
      conn
      |> put_status(200)
      |> json(%{data: vendor})
    end
  end

  def delete(conn, %{"id" => id}) do
    vendor = Vendors.get!(id)

    with {:ok, %Vendor{}} <- Vendors.delete(vendor) do
      send_resp(conn, :no_content, "")
    end
  end
end
