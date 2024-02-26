defmodule SFFoodTrucksWeb.VendorControllerTest do
  use SFFoodTrucksWeb.ConnCase

  import SFFoodTrucks.VendorsFixtures

  alias SFFoodTrucks.Vendors.Vendor

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vendors", %{conn: conn} do
      conn = get(conn, ~p"/api/vendors")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create vendor" do
    test "renders vendor when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/vendors", vendor: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/vendors/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/vendors", vendor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vendor" do
    setup [:create]

    test "renders vendor when data is valid", %{conn: conn, vendor: %Vendor{id: id} = vendor} do
      conn = put(conn, ~p"/api/vendors/#{vendor}", vendor: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/vendors/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, vendor: vendor} do
      conn = put(conn, ~p"/api/vendors/#{vendor}", vendor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vendor" do
    setup [:create]

    test "deletes chosen vendor", %{conn: conn, vendor: vendor} do
      conn = delete(conn, ~p"/api/vendors/#{vendor}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/vendors/#{vendor}")
      end
    end
  end

  defp create(_) do
    vendor = vendor_fixture()
    %{vendor: vendor}
  end
end