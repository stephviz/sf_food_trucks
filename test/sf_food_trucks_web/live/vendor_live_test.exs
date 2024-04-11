defmodule SFFoodTrucksWeb.VendorLiveTest do
  use SFFoodTrucksWeb.ConnCase

  import Phoenix.LiveViewTest
  import SFFoodTrucks.VendorsFixtures

  @create_attrs %{
    block: "42",
    name: "some name",
    status: :ISSUED,
    type: "Truck",
    zip: 42119,
    address: "some address",
    permit: "15MFF-0000",
    location: "(111, -222)",
    approved: "03/16/2019 12:00:00 AM",
    location_id: 42,
    cnn: 424242,
    location_desc: "some location_desc",
    block_lot: "42",
    lot: "42",
    food_items: "some food_items",
    x_coordinate: 120.5,
    y_coordinate: 120.5,
    latitude: 111,
    longitude: -222,
    schedule: "some schedule",
    days_hours: "Mo-We:7AM-7PM",
    received: "20160908",
    expiration_date: "03/15/2029 12:00:00 AM"
  }
  @update_attrs %{
    block: "43",
    name: "some updated name",
    status: :APPROVED,
    type: "Unknown",
    zip: 434343,
    address: "some updated address",
    permit: "some updated permit",
    location: "some updated location",
    approved: "09/16/2017 12:00:00 AM",
    location_id: 43,
    cnn: 44433333,
    location_desc: "some updated location_desc",
    block_lot: "43",
    lot: "43",
    food_items: "some updated food_items",
    x_coordinate: 456.7,
    y_coordinate: 456.7,
    latitude: 333.7,
    longitude: -444,
    schedule: "some updated schedule",
    days_hours: "some updated days_hours",
    received: "20150401",
    expiration_date: "09/16/2027 12:00:00 AM"
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
