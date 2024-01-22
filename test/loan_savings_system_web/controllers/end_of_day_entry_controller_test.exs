defmodule LoanSavingsSystemWeb.EndOfDayEntryControllerTest do
  use LoanSavingsSystemWeb.ConnCase

  alias LoanSavingsSystem.EndOfDay

  @create_attrs %{currencyId: 42, currencyName: "some currencyName", end_of_day_date: ~N[2010-04-17 14:00:00], end_of_day_id: 42, interest_accrued: 120.5, penalties_incurred: 120.5, status: "some status"}
  @update_attrs %{currencyId: 43, currencyName: "some updated currencyName", end_of_day_date: ~N[2011-05-18 15:01:01], end_of_day_id: 43, interest_accrued: 456.7, penalties_incurred: 456.7, status: "some updated status"}
  @invalid_attrs %{currencyId: nil, currencyName: nil, end_of_day_date: nil, end_of_day_id: nil, interest_accrued: nil, penalties_incurred: nil, status: nil}

  def fixture(:end_of_day_entry) do
    {:ok, end_of_day_entry} = EndOfDay.create_end_of_day_entry(@create_attrs)
    end_of_day_entry
  end

  describe "index" do
    test "lists all tbl_end_of_day_entries", %{conn: conn} do
      conn = get(conn, Routes.end_of_day_entry_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tbl end of day entries"
    end
  end

  describe "new end_of_day_entry" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.end_of_day_entry_path(conn, :new))
      assert html_response(conn, 200) =~ "New End of day entry"
    end
  end

  describe "create end_of_day_entry" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.end_of_day_entry_path(conn, :create), end_of_day_entry: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.end_of_day_entry_path(conn, :show, id)

      conn = get(conn, Routes.end_of_day_entry_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show End of day entry"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.end_of_day_entry_path(conn, :create), end_of_day_entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "New End of day entry"
    end
  end

  describe "edit end_of_day_entry" do
    setup [:create_end_of_day_entry]

    test "renders form for editing chosen end_of_day_entry", %{conn: conn, end_of_day_entry: end_of_day_entry} do
      conn = get(conn, Routes.end_of_day_entry_path(conn, :edit, end_of_day_entry))
      assert html_response(conn, 200) =~ "Edit End of day entry"
    end
  end

  describe "update end_of_day_entry" do
    setup [:create_end_of_day_entry]

    test "redirects when data is valid", %{conn: conn, end_of_day_entry: end_of_day_entry} do
      conn = put(conn, Routes.end_of_day_entry_path(conn, :update, end_of_day_entry), end_of_day_entry: @update_attrs)
      assert redirected_to(conn) == Routes.end_of_day_entry_path(conn, :show, end_of_day_entry)

      conn = get(conn, Routes.end_of_day_entry_path(conn, :show, end_of_day_entry))
      assert html_response(conn, 200) =~ "some updated currencyName"
    end

    test "renders errors when data is invalid", %{conn: conn, end_of_day_entry: end_of_day_entry} do
      conn = put(conn, Routes.end_of_day_entry_path(conn, :update, end_of_day_entry), end_of_day_entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit End of day entry"
    end
  end

  describe "delete end_of_day_entry" do
    setup [:create_end_of_day_entry]

    test "deletes chosen end_of_day_entry", %{conn: conn, end_of_day_entry: end_of_day_entry} do
      conn = delete(conn, Routes.end_of_day_entry_path(conn, :delete, end_of_day_entry))
      assert redirected_to(conn) == Routes.end_of_day_entry_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.end_of_day_entry_path(conn, :show, end_of_day_entry))
      end
    end
  end

  defp create_end_of_day_entry(_) do
    end_of_day_entry = fixture(:end_of_day_entry)
    {:ok, end_of_day_entry: end_of_day_entry}
  end
end
