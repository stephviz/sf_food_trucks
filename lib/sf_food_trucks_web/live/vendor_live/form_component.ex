defmodule SFFoodTrucksWeb.VendorLive.FormComponent do
  use SFFoodTrucksWeb, :live_component

  alias SFFoodTrucks.Vendors

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage vendor records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="vendor-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:location_id]} type="number" label="Location" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:type]} type="text" label="Type" />
        <.input field={@form[:cnn]} type="number" label="Cnn" />
        <.input field={@form[:location_desc]} type="text" label="Location desc" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:block_lot]} type="number" label="Block lot" />
        <.input field={@form[:block]} type="number" label="Block" />
        <.input field={@form[:lot]} type="number" label="Lot" />
        <.input field={@form[:permit]} type="text" label="Permit" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:food_items]} type="text" label="Food items" />
        <.input field={@form[:x_coordinate]} type="number" label="X coordinate" step="any" />
        <.input field={@form[:y_coordinate]} type="number" label="Y coordinate" step="any" />
        <.input field={@form[:latitude]} type="number" label="Latitude" step="any" />
        <.input field={@form[:schedule]} type="text" label="Schedule" />
        <.input field={@form[:days_hours]} type="text" label="Days hours" />
        <.input field={@form[:approved]} type="datetime-local" label="Approved" />
        <.input field={@form[:received]} type="datetime-local" label="Received" />
        <.input field={@form[:expiration_date]} type="datetime-local" label="Expiration date" />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:zip]} type="number" label="Zip" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Vendor</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{vendor: vendor} = assigns, socket) do
    changeset = Vendors.change(vendor)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"vendor" => vendor_params}, socket) do
    changeset =
      socket.assigns.vendor
      |> Vendors.change(vendor_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"vendor" => vendor_params}, socket) do
    save_vendor(socket, socket.assigns.action, vendor_params)
  end

  defp save_vendor(socket, :edit, vendor_params) do
    case Vendors.update(socket.assigns.vendor, vendor_params) do
      {:ok, vendor} ->
        notify_parent({:saved, vendor})

        {:noreply,
         socket
         |> put_flash(:info, "Vendor updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_vendor(socket, :new, vendor_params) do
    case Vendors.create(vendor_params) do
      {:ok, vendor} ->
        notify_parent({:saved, vendor})

        {:noreply,
         socket
         |> put_flash(:info, "Vendor created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
