defmodule LoanSavingsSystemWeb.EndOfDayRunControllerTest do
  use LoanSavingsSystemWeb.ConnCase

  alias LoanSavingsSystem.EndOfDay

  @create_attrs %{currencyId: 42, currencyName: "some currencyName", date_ran: ~N[2010-04-17 14:00:00], end_date: ~N[2010-04-17 14:00:00], end_of_day_type: "some end_of_day_type", penalties_incurred: 120.5, start_date: ~N[2010-04-17 14:00:00], status: "some status", total_interest_accrued: 120.5}
  @update_attrs %{currencyId: 43, currencyName: "some updated currencyName", date_ran: ~N[2011-05-18 15:01:01], end_date: ~N[2011-05-18 15:01:01], end_of_day_type: "some updated end_of_day_type", penalties_incurred: 456.7, start_date: ~N[2011-05-18 15:01:01], status: "some updated status", total_interest_accrued: 456.7}
  @invalid_attrs %{currencyId: nil, currencyName: nil, date_ran: nil, end_date: nil, end_of_day_type: nil, penalties_incurred: nil, start_date: nil, status: nil, total_interest_accrued: nil}

  def fixture(:end_of_day_run) do
    {:ok, end_of_day_run} = EndOfDay.create_end_of_day_run(@create_attrs)
    end_of_day_run
  end

  describe "index" do
    test "lists all tbl_end_of_day", %{conn: conn} do
      conn = get(conn, Routes.end_of_day_run_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tbl end of day"
    end
  end

  describe "new end_of_day_run" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.end_of_day_run_path(conn, :new))
      assert html_response(conn, 200) =~ "New End of day run"
    end
  end

  describe "create end_of_day_run" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.end_of_day_run_path(conn, :create), end_of_day_run: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.end_of_day_run_path(conn, :show, id)

      conn = get(conn, Routes.end_of_day_run_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show End of day run"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.end_of_day_run_path(conn, :create), end_of_day_run: @invalid_attrs)
      assert html_response(conn, 200) =~ "New End of day run"
    end
  end

  describe "edit end_of_day_run" do
    setup [:create_end_of_day_run]

    test "renders form for editing chosen end_of_day_run", %{conn: conn, end_of_day_run: end_of_day_run} do
      conn = get(conn, Routes.end_of_day_run_path(conn, :edit, end_of_day_run))
      assert html_response(conn, 200) =~ "Edit End of day run"
    end
  end

  describe "update end_of_day_run" do
    setup [:create_end_of_day_run]

    test "redirects when data is valid", %{conn: conn, end_of_day_run: end_of_day_run} do
      conn = put(conn, Routes.end_of_day_run_path(conn, :update, end_of_day_run), end_of_day_run: @update_attrs)
      assert redirected_to(conn) == Routes.end_of_day_run_path(conn, :show, end_of_day_run)

      conn = get(conn, Routes.end_of_day_run_path(conn, :show, end_of_day_run))
      assert html_response(conn, 200) =~ "some updated currencyName"
    end

    test "renders errors when data is invalid", %{conn: conn, end_of_day_run: end_of_day_run} do
      conn = put(conn, Routes.end_of_day_run_path(conn, :update, end_of_day_run), end_of_day_run: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit End of day run"
    end
  end

  describe "delete end_of_day_run" do
    setup [:create_end_of_day_run]

    test "deletes chosen end_of_day_run", %{conn: conn, end_of_day_run: end_of_day_run} do
      conn = delete(conn, Routes.end_of_day_run_path(conn, :delete, end_of_day_run))
      assert redirected_to(conn) == Routes.end_of_day_run_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.end_of_day_run_path(conn, :show, end_of_day_run))
      end
    end
  end

  defp create_end_of_day_run(_) do
    end_of_day_run = fixture(:end_of_day_run)
    {:ok, end_of_day_run: end_of_day_run}
  end
end
