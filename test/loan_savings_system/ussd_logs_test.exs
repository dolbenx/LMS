defmodule LoanSavingsSystem.UssdLogsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.UssdLogs

  describe "tbl_ussd_logs" do
    alias LoanSavingsSystem.UssdLogs.UssdLog

    @valid_attrs %{action: "some action", parentRoute: "some parentRoute", status: "some status", userId: 42}
    @update_attrs %{action: "some updated action", parentRoute: "some updated parentRoute", status: "some updated status", userId: 43}
    @invalid_attrs %{action: nil, parentRoute: nil, status: nil, userId: nil}

    def ussd_log_fixture(attrs \\ %{}) do
      {:ok, ussd_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UssdLogs.create_ussd_log()

      ussd_log
    end

    test "list_tbl_ussd_logs/0 returns all tbl_ussd_logs" do
      ussd_log = ussd_log_fixture()
      assert UssdLogs.list_tbl_ussd_logs() == [ussd_log]
    end

    test "get_ussd_log!/1 returns the ussd_log with given id" do
      ussd_log = ussd_log_fixture()
      assert UssdLogs.get_ussd_log!(ussd_log.id) == ussd_log
    end

    test "create_ussd_log/1 with valid data creates a ussd_log" do
      assert {:ok, %UssdLog{} = ussd_log} = UssdLogs.create_ussd_log(@valid_attrs)
      assert ussd_log.action == "some action"
      assert ussd_log.parentRoute == "some parentRoute"
      assert ussd_log.status == "some status"
      assert ussd_log.userId == 42
    end

    test "create_ussd_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UssdLogs.create_ussd_log(@invalid_attrs)
    end

    test "update_ussd_log/2 with valid data updates the ussd_log" do
      ussd_log = ussd_log_fixture()
      assert {:ok, %UssdLog{} = ussd_log} = UssdLogs.update_ussd_log(ussd_log, @update_attrs)
      assert ussd_log.action == "some updated action"
      assert ussd_log.parentRoute == "some updated parentRoute"
      assert ussd_log.status == "some updated status"
      assert ussd_log.userId == 43
    end

    test "update_ussd_log/2 with invalid data returns error changeset" do
      ussd_log = ussd_log_fixture()
      assert {:error, %Ecto.Changeset{}} = UssdLogs.update_ussd_log(ussd_log, @invalid_attrs)
      assert ussd_log == UssdLogs.get_ussd_log!(ussd_log.id)
    end

    test "delete_ussd_log/1 deletes the ussd_log" do
      ussd_log = ussd_log_fixture()
      assert {:ok, %UssdLog{}} = UssdLogs.delete_ussd_log(ussd_log)
      assert_raise Ecto.NoResultsError, fn -> UssdLogs.get_ussd_log!(ussd_log.id) end
    end

    test "change_ussd_log/1 returns a ussd_log changeset" do
      ussd_log = ussd_log_fixture()
      assert %Ecto.Changeset{} = UssdLogs.change_ussd_log(ussd_log)
    end
  end
end
