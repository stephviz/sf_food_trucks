defmodule SfFoodTrucksWeb.VendorLive.Index do
  use SfFoodTrucksWeb, :live_view

  alias SfFoodTrucks.Vendors
  alias SfFoodTrucks.Vendors.Vendor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :vendors, Vendors.list())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Vendor")
    |> assign(:vendor, Vendors.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Vendor")
    |> assign(:vendor, %Vendor{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Vendors")
    |> assign(:vendor, nil)
  end

  @impl true
  def handle_info({SfFoodTrucksWeb.VendorLive.FormComponent, {:saved, vendor}}, socket) do
    {:noreply, stream_insert(socket, :vendors, vendor)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vendor = Vendors.get!(id)
    {:ok, _} = Vendors.delete(vendor)

    {:noreply, stream_delete(socket, :vendors, vendor)}
  end
end
