defmodule LoanSavingsSystemWeb.FcubeReqResControllerTest do
  use LoanSavingsSystemWeb.ConnCase

  alias LoanSavingsSystem.EndOfDay

  @create_attrs %{request_data: "some request_data", response_data: "some response_data"}
  @update_attrs %{request_data: "some updated request_data", response_data: "some updated response_data"}
  @invalid_attrs %{request_data: nil, response_data: nil}

  def fixture(:fcube_req_res) do
    {:ok, fcube_req_res} = EndOfDay.create_fcube_req_res(@create_attrs)
    fcube_req_res
  end

  describe "index" do
    test "lists all fcube_request_responses", %{conn: conn} do
      conn = get(conn, Routes.fcube_req_res_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Fcube request responses"
    end
  end

  describe "new fcube_req_res" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.fcube_req_res_path(conn, :new))
      assert html_response(conn, 200) =~ "New Fcube req res"
    end
  end

  describe "create fcube_req_res" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.fcube_req_res_path(conn, :create), fcube_req_res: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.fcube_req_res_path(conn, :show, id)

      conn = get(conn, Routes.fcube_req_res_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Fcube req res"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.fcube_req_res_path(conn, :create), fcube_req_res: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Fcube req res"
    end
  end

  describe "edit fcube_req_res" do
    setup [:create_fcube_req_res]

    test "renders form for editing chosen fcube_req_res", %{conn: conn, fcube_req_res: fcube_req_res} do
      conn = get(conn, Routes.fcube_req_res_path(conn, :edit, fcube_req_res))
      assert html_response(conn, 200) =~ "Edit Fcube req res"
    end
  end

  describe "update fcube_req_res" do
    setup [:create_fcube_req_res]

    test "redirects when data is valid", %{conn: conn, fcube_req_res: fcube_req_res} do
      conn = put(conn, Routes.fcube_req_res_path(conn, :update, fcube_req_res), fcube_req_res: @update_attrs)
      assert redirected_to(conn) == Routes.fcube_req_res_path(conn, :show, fcube_req_res)

      conn = get(conn, Routes.fcube_req_res_path(conn, :show, fcube_req_res))
      assert html_response(conn, 200) =~ "some updated request_data"
    end

    test "renders errors when data is invalid", %{conn: conn, fcube_req_res: fcube_req_res} do
      conn = put(conn, Routes.fcube_req_res_path(conn, :update, fcube_req_res), fcube_req_res: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Fcube req res"
    end
  end

  describe "delete fcube_req_res" do
    setup [:create_fcube_req_res]

    test "deletes chosen fcube_req_res", %{conn: conn, fcube_req_res: fcube_req_res} do
      conn = delete(conn, Routes.fcube_req_res_path(conn, :delete, fcube_req_res))
      assert redirected_to(conn) == Routes.fcube_req_res_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.fcube_req_res_path(conn, :show, fcube_req_res))
      end
    end
  end

  defp create_fcube_req_res(_) do
    fcube_req_res = fixture(:fcube_req_res)
    {:ok, fcube_req_res: fcube_req_res}
  end
end
