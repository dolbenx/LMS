defmodule LoanmanagementsystemWeb.ProvinceControllerTest do
  use LoanmanagementsystemWeb.ConnCase

  alias Loanmanagementsystem.Maintenance

  @create_attrs %{countryId: 42, countryName: "some countryName", name: "some name"}
  @update_attrs %{
    countryId: 43,
    countryName: "some updated countryName",
    name: "some updated name"
  }
  @invalid_attrs %{countryId: nil, countryName: nil, name: nil}

  def fixture(:province) do
    {:ok, province} = Maintenance.create_province(@create_attrs)
    province
  end

  describe "index" do
    test "lists all tbl_province", %{conn: conn} do
      conn = get(conn, Routes.province_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tbl province"
    end
  end

  describe "new province" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.province_path(conn, :new))
      assert html_response(conn, 200) =~ "New Province"
    end
  end

  describe "create province" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.province_path(conn, :create), province: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.province_path(conn, :show, id)

      conn = get(conn, Routes.province_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Province"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.province_path(conn, :create), province: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Province"
    end
  end

  describe "edit province" do
    setup [:create_province]

    test "renders form for editing chosen province", %{conn: conn, province: province} do
      conn = get(conn, Routes.province_path(conn, :edit, province))
      assert html_response(conn, 200) =~ "Edit Province"
    end
  end

  describe "update province" do
    setup [:create_province]

    test "redirects when data is valid", %{conn: conn, province: province} do
      conn = put(conn, Routes.province_path(conn, :update, province), province: @update_attrs)
      assert redirected_to(conn) == Routes.province_path(conn, :show, province)

      conn = get(conn, Routes.province_path(conn, :show, province))
      assert html_response(conn, 200) =~ "some updated countryName"
    end

    test "renders errors when data is invalid", %{conn: conn, province: province} do
      conn = put(conn, Routes.province_path(conn, :update, province), province: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Province"
    end
  end

  describe "delete province" do
    setup [:create_province]

    test "deletes chosen province", %{conn: conn, province: province} do
      conn = delete(conn, Routes.province_path(conn, :delete, province))
      assert redirected_to(conn) == Routes.province_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.province_path(conn, :show, province))
      end
    end
  end

  defp create_province(_) do
    province = fixture(:province)
    %{province: province}
  end
end
