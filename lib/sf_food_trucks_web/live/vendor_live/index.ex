defmodule SFFoodTrucksWeb.VendorLive.Index do
  use SFFoodTrucksWeb, :live_view
  require Logger

  alias SFFoodTrucks.Vendors
  alias SFFoodTrucks.Vendors.Vendor
  alias SFFoodTrucks.Workers.FetchVendorsWorker

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(SFFoodTrucks.PubSub, "fetch_vendors")
    end

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
  def handle_info({SFFoodTrucksWeb.VendorLive.FormComponent, {:saved, vendor}}, socket) do
    {:noreply, stream_insert(socket, :vendors, vendor)}
  end

  @impl true
  def handle_info({:fetch_vendors_success, result}, socket) do
    %{
      records_processed: records_processed,
      records_created: records_created
    } = result

    socket =
      put_flash(
        socket,
        :info,
        "#{records_processed} vendors processed, #{records_created} new records created"
      )

    {:noreply, stream(socket, :vendors, Vendors.list())}
  end

  @impl true
  def handle_info({:fetch_vendors_error, job}, socket) do
    Logger.error("Fetch vendor worker failure `#{inspect(job)}`")

    socket = put_flash(socket, :error, "Unable to fetch vendors")
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vendor = Vendors.get!(id)
    {:ok, _} = Vendors.delete(vendor)

    {:noreply, stream_delete(socket, :vendors, vendor)}
  end

  @impl true
  def handle_event("fetch", _params, socket) do
    %{}
    |> FetchVendorsWorker.new()
    |> Oban.insert()

    {:noreply, socket}
  end
end
