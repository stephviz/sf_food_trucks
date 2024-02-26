defmodule SFFoodTrucksWeb.VendorLiveTest do
  use SFFoodTrucksWeb.ConnCase

  import Phoenix.LiveViewTest
  import SFFoodTrucks.VendorsFixtures

  @create_attrs %{
    block: 42,
    name: "some name",
    status: "some status",
    type: "some type",
    zip: 42,
    address: "some address",
    permit: "some permit",
    location: "some location",
    approved: "2024-02-25T05:56:00Z",
    location_id: 42,
    cnn: 42,
    location_desc: "some location_desc",
    block_lot: 42,
    lot: 42,
    food_items: "some food_items",
    x_coordinate: 120.5,
    y_coordinate: 120.5,
    latitude: 120.5,
    schedule: "some schedule",
    days_hours: "some days_hours",
    received: "2024-02-25T05:56:00Z",
    expiration_date: "2024-02-25T05:56:00Z"
  }
  @update_attrs %{
    block: 43,
    name: "some updated name",
    status: "some updated status",
    type: "some updated type",
    zip: 43,
    address: "some updated address",
    permit: "some updated permit",
    location: "some updated location",
    approved: "2024-02-26T05:56:00Z",
    location_id: 43,
    cnn: 43,
    location_desc: "some updated location_desc",
    block_lot: 43,
    lot: 43,
    food_items: "some updated food_items",
    x_coordinate: 456.7,
    y_coordinate: 456.7,
    latitude: 456.7,
    schedule: "some updated schedule",
    days_hours: "some updated days_hours",
    received: "2024-02-26T05:56:00Z",
    expiration_date: "2024-02-26T05:56:00Z"
  }
  @invalid_attrs %{
    block: nil,
    name: nil,
    status: nil,
    type: nil,
    zip: nil,
    address: nil,
    permit: nil,
    location: nil,
    approved: nil,
    location_id: nil,
    cnn: nil,
    location_desc: nil,
    block_lot: nil,
    lot: nil,
    food_items: nil,
    x_coordinate: nil,
    y_coordinate: nil,
    latitude: nil,
    schedule: nil,
    days_hours: nil,
    received: nil,
    expiration_date: nil
  }

  defp create(_) do
    vendor = vendor_fixture()
    %{vendor: vendor}
  end

  describe "Index" do
    setup [:create]

    test "lists all vendors", %{conn: conn, vendor: vendor} do
      {:ok, _index_live, html} = live(conn, ~p"/vendors")

      assert html =~ "Listing Vendors"
      assert html =~ vendor.name
    end

    test "saves new vendor", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/vendors")

      assert index_live |> element("a", "New Vendor") |> render_click() =~
               "New Vendor"

      assert_patch(index_live, ~p"/vendors/new")

      assert index_live
             |> form("#vendor-form", vendor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vendor-form", vendor: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/vendors")

      html = render(index_live)
      assert html =~ "Vendor created successfully"
      assert html =~ "some name"
    end

    test "updates vendor in listing", %{conn: conn, vendor: vendor} do
      {:ok, index_live, _html} = live(conn, ~p"/vendors")

      assert index_live |> element("#vendors-#{vendor.id} a", "Edit") |> render_click() =~
               "Edit Vendor"

      assert_patch(index_live, ~p"/vendors/#{vendor}/edit")

      assert index_live
             |> form("#vendor-form", vendor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vendor-form", vendor: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/vendors")

      html = render(index_live)
      assert html =~ "Vendor updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes vendor in listing", %{conn: conn, vendor: vendor} do
      {:ok, index_live, _html} = live(conn, ~p"/vendors")

      assert index_live |> element("#vendors-#{vendor.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vendors-#{vendor.id}")
    end
  end

  describe "Show" do
    setup [:create]

    test "displays vendor", %{conn: conn, vendor: vendor} do
      {:ok, _show_live, html} = live(conn, ~p"/vendors/#{vendor}")

      assert html =~ "Show Vendor"
      assert html =~ vendor.name
    end

    test "updates vendor within modal", %{conn: conn, vendor: vendor} do
      {:ok, show_live, _html} = live(conn, ~p"/vendors/#{vendor}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Vendor"

      assert_patch(show_live, ~p"/vendors/#{vendor}/show/edit")

      assert show_live
             |> form("#vendor-form", vendor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#vendor-form", vendor: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/vendors/#{vendor}")

      html = render(show_live)
      assert html =~ "Vendor updated successfully"
      assert html =~ "some updated name"
    end
  end
end
