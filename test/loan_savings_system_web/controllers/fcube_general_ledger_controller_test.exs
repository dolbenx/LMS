defmodule LoanSavingsSystemWeb.FcubeGeneralLedgerControllerTest do
  use LoanSavingsSystemWeb.ConnCase

  alias LoanSavingsSystem.EndOfDay

  @create_attrs %{account_name: "some account_name", gl_account_no: "some gl_account_no"}
  @update_attrs %{account_name: "some updated account_name", gl_account_no: "some updated gl_account_no"}
  @invalid_attrs %{account_name: nil, gl_account_no: nil}

  def fixture(:fcube_general_ledger) do
    {:ok, fcube_general_ledger} = EndOfDay.create_fcube_general_ledger(@create_attrs)
    fcube_general_ledger
  end

  describe "index" do
    test "lists all fcube_general_ledger", %{conn: conn} do
      conn = get(conn, Routes.fcube_general_ledger_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Fcube general ledger"
    end
  end

  describe "new fcube_general_ledger" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.fcube_general_ledger_path(conn, :new))
      assert html_response(conn, 200) =~ "New Fcube general ledger"
    end
  end

  describe "create fcube_general_ledger" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.fcube_general_ledger_path(conn, :create), fcube_general_ledger: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.fcube_general_ledger_path(conn, :show, id)

      conn = get(conn, Routes.fcube_general_ledger_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Fcube general ledger"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.fcube_general_ledger_path(conn, :create), fcube_general_ledger: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Fcube general ledger"
    end
  end

  describe "edit fcube_general_ledger" do
    setup [:create_fcube_general_ledger]

    test "renders form for editing chosen fcube_general_ledger", %{conn: conn, fcube_general_ledger: fcube_general_ledger} do
      conn = get(conn, Routes.fcube_general_ledger_path(conn, :edit, fcube_general_ledger))
      assert html_response(conn, 200) =~ "Edit Fcube general ledger"
    end
  end

  describe "update fcube_general_ledger" do
    setup [:create_fcube_general_ledger]

    test "redirects when data is valid", %{conn: conn, fcube_general_ledger: fcube_general_ledger} do
      conn = put(conn, Routes.fcube_general_ledger_path(conn, :update, fcube_general_ledger), fcube_general_ledger: @update_attrs)
      assert redirected_to(conn) == Routes.fcube_general_ledger_path(conn, :show, fcube_general_ledger)

      conn = get(conn, Routes.fcube_general_ledger_path(conn, :show, fcube_general_ledger))
      assert html_response(conn, 200) =~ "some updated account_name"
    end

    test "renders errors when data is invalid", %{conn: conn, fcube_general_ledger: fcube_general_ledger} do
      conn = put(conn, Routes.fcube_general_ledger_path(conn, :update, fcube_general_ledger), fcube_general_ledger: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Fcube general ledger"
    end
  end

  describe "delete fcube_general_ledger" do
    setup [:create_fcube_general_ledger]

    test "deletes chosen fcube_general_ledger", %{conn: conn, fcube_general_ledger: fcube_general_ledger} do
      conn = delete(conn, Routes.fcube_general_ledger_path(conn, :delete, fcube_general_ledger))
      assert redirected_to(conn) == Routes.fcube_general_ledger_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.fcube_general_ledger_path(conn, :show, fcube_general_ledger))
      end
    end
  end

  defp create_fcube_general_ledger(_) do
    fcube_general_ledger = fixture(:fcube_general_ledger)
    {:ok, fcube_general_ledger: fcube_general_ledger}
  end
end
