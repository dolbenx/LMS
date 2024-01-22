defmodule LoanSavingsSystemWeb.UssdRequestControllerTest do
  use LoanSavingsSystemWeb.ConnCase

  alias LoanSavingsSystem.Ussd

  @create_attrs %{is_logged_in: 42, mobile_number: "some mobile_number", request_data: "some request_data", session_ended: 42, session_id: "some session_id"}
  @update_attrs %{is_logged_in: 43, mobile_number: "some updated mobile_number", request_data: "some updated request_data", session_ended: 43, session_id: "some updated session_id"}
  @invalid_attrs %{is_logged_in: nil, mobile_number: nil, request_data: nil, session_ended: nil, session_id: nil}

  def fixture(:ussd_request) do
    {:ok, ussd_request} = Ussd.create_ussd_request(@create_attrs)
    ussd_request
  end

  describe "index" do
    test "lists all ussd_requests", %{conn: conn} do
      conn = get(conn, Routes.ussd_request_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Ussd requests"
    end
  end

  describe "new ussd_request" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.ussd_request_path(conn, :new))
      assert html_response(conn, 200) =~ "New Ussd request"
    end
  end

  describe "create ussd_request" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.ussd_request_path(conn, :create), ussd_request: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.ussd_request_path(conn, :show, id)

      conn = get(conn, Routes.ussd_request_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Ussd request"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ussd_request_path(conn, :create), ussd_request: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ussd request"
    end
  end

  describe "edit ussd_request" do
    setup [:create_ussd_request]

    test "renders form for editing chosen ussd_request", %{conn: conn, ussd_request: ussd_request} do
      conn = get(conn, Routes.ussd_request_path(conn, :edit, ussd_request))
      assert html_response(conn, 200) =~ "Edit Ussd request"
    end
  end

  describe "update ussd_request" do
    setup [:create_ussd_request]

    test "redirects when data is valid", %{conn: conn, ussd_request: ussd_request} do
      conn = put(conn, Routes.ussd_request_path(conn, :update, ussd_request), ussd_request: @update_attrs)
      assert redirected_to(conn) == Routes.ussd_request_path(conn, :show, ussd_request)

      conn = get(conn, Routes.ussd_request_path(conn, :show, ussd_request))
      assert html_response(conn, 200) =~ "some updated mobile_number"
    end

    test "renders errors when data is invalid", %{conn: conn, ussd_request: ussd_request} do
      conn = put(conn, Routes.ussd_request_path(conn, :update, ussd_request), ussd_request: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Ussd request"
    end
  end

  describe "delete ussd_request" do
    setup [:create_ussd_request]

    test "deletes chosen ussd_request", %{conn: conn, ussd_request: ussd_request} do
      conn = delete(conn, Routes.ussd_request_path(conn, :delete, ussd_request))
      assert redirected_to(conn) == Routes.ussd_request_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.ussd_request_path(conn, :show, ussd_request))
      end
    end
  end

  defp create_ussd_request(_) do
    ussd_request = fixture(:ussd_request)
    {:ok, ussd_request: ussd_request}
  end
end
