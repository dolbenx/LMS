defmodule LoanSavingsSystem.FlexcubeLogsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.FlexcubeLogs

  describe "flexcubeconfigs" do
    alias LoanSavingsSystem.FlexcubeLogs.FlexcubeLog

    @valid_attrs %{action_type: "some action_type", endpoint: "some endpoint", request: "some request", response_data: "some response_data", status: "some status"}
    @update_attrs %{action_type: "some updated action_type", endpoint: "some updated endpoint", request: "some updated request", response_data: "some updated response_data", status: "some updated status"}
    @invalid_attrs %{action_type: nil, endpoint: nil, request: nil, response_data: nil, status: nil}

    def flexcube_log_fixture(attrs \\ %{}) do
      {:ok, flexcube_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FlexcubeLogs.create_flexcube_log()

      flexcube_log
    end

    test "list_flexcubeconfigs/0 returns all flexcubeconfigs" do
      flexcube_log = flexcube_log_fixture()
      assert FlexcubeLogs.list_flexcubeconfigs() == [flexcube_log]
    end

    test "get_flexcube_log!/1 returns the flexcube_log with given id" do
      flexcube_log = flexcube_log_fixture()
      assert FlexcubeLogs.get_flexcube_log!(flexcube_log.id) == flexcube_log
    end

    test "create_flexcube_log/1 with valid data creates a flexcube_log" do
      assert {:ok, %FlexcubeLog{} = flexcube_log} = FlexcubeLogs.create_flexcube_log(@valid_attrs)
      assert flexcube_log.action_type == "some action_type"
      assert flexcube_log.endpoint == "some endpoint"
      assert flexcube_log.request == "some request"
      assert flexcube_log.response_data == "some response_data"
      assert flexcube_log.status == "some status"
    end

    test "create_flexcube_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FlexcubeLogs.create_flexcube_log(@invalid_attrs)
    end

    test "update_flexcube_log/2 with valid data updates the flexcube_log" do
      flexcube_log = flexcube_log_fixture()
      assert {:ok, %FlexcubeLog{} = flexcube_log} = FlexcubeLogs.update_flexcube_log(flexcube_log, @update_attrs)
      assert flexcube_log.action_type == "some updated action_type"
      assert flexcube_log.endpoint == "some updated endpoint"
      assert flexcube_log.request == "some updated request"
      assert flexcube_log.response_data == "some updated response_data"
      assert flexcube_log.status == "some updated status"
    end

    test "update_flexcube_log/2 with invalid data returns error changeset" do
      flexcube_log = flexcube_log_fixture()
      assert {:error, %Ecto.Changeset{}} = FlexcubeLogs.update_flexcube_log(flexcube_log, @invalid_attrs)
      assert flexcube_log == FlexcubeLogs.get_flexcube_log!(flexcube_log.id)
    end

    test "delete_flexcube_log/1 deletes the flexcube_log" do
      flexcube_log = flexcube_log_fixture()
      assert {:ok, %FlexcubeLog{}} = FlexcubeLogs.delete_flexcube_log(flexcube_log)
      assert_raise Ecto.NoResultsError, fn -> FlexcubeLogs.get_flexcube_log!(flexcube_log.id) end
    end

    test "change_flexcube_log/1 returns a flexcube_log changeset" do
      flexcube_log = flexcube_log_fixture()
      assert %Ecto.Changeset{} = FlexcubeLogs.change_flexcube_log(flexcube_log)
    end
  end

  describe "flexcubelogs" do
    alias LoanSavingsSystem.FlexcubeLogs.FlexcubeLog

    @valid_attrs %{action_type: "some action_type", endpoint: "some endpoint", request: "some request", response_data: "some response_data", status: "some status"}
    @update_attrs %{action_type: "some updated action_type", endpoint: "some updated endpoint", request: "some updated request", response_data: "some updated response_data", status: "some updated status"}
    @invalid_attrs %{action_type: nil, endpoint: nil, request: nil, response_data: nil, status: nil}

    def flexcube_log_fixture(attrs \\ %{}) do
      {:ok, flexcube_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FlexcubeLogs.create_flexcube_log()

      flexcube_log
    end

    test "list_flexcubelogs/0 returns all flexcubelogs" do
      flexcube_log = flexcube_log_fixture()
      assert FlexcubeLogs.list_flexcubelogs() == [flexcube_log]
    end

    test "get_flexcube_log!/1 returns the flexcube_log with given id" do
      flexcube_log = flexcube_log_fixture()
      assert FlexcubeLogs.get_flexcube_log!(flexcube_log.id) == flexcube_log
    end

    test "create_flexcube_log/1 with valid data creates a flexcube_log" do
      assert {:ok, %FlexcubeLog{} = flexcube_log} = FlexcubeLogs.create_flexcube_log(@valid_attrs)
      assert flexcube_log.action_type == "some action_type"
      assert flexcube_log.endpoint == "some endpoint"
      assert flexcube_log.request == "some request"
      assert flexcube_log.response_data == "some response_data"
      assert flexcube_log.status == "some status"
    end

    test "create_flexcube_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FlexcubeLogs.create_flexcube_log(@invalid_attrs)
    end

    test "update_flexcube_log/2 with valid data updates the flexcube_log" do
      flexcube_log = flexcube_log_fixture()
      assert {:ok, %FlexcubeLog{} = flexcube_log} = FlexcubeLogs.update_flexcube_log(flexcube_log, @update_attrs)
      assert flexcube_log.action_type == "some updated action_type"
      assert flexcube_log.endpoint == "some updated endpoint"
      assert flexcube_log.request == "some updated request"
      assert flexcube_log.response_data == "some updated response_data"
      assert flexcube_log.status == "some updated status"
    end

    test "update_flexcube_log/2 with invalid data returns error changeset" do
      flexcube_log = flexcube_log_fixture()
      assert {:error, %Ecto.Changeset{}} = FlexcubeLogs.update_flexcube_log(flexcube_log, @invalid_attrs)
      assert flexcube_log == FlexcubeLogs.get_flexcube_log!(flexcube_log.id)
    end

    test "delete_flexcube_log/1 deletes the flexcube_log" do
      flexcube_log = flexcube_log_fixture()
      assert {:ok, %FlexcubeLog{}} = FlexcubeLogs.delete_flexcube_log(flexcube_log)
      assert_raise Ecto.NoResultsError, fn -> FlexcubeLogs.get_flexcube_log!(flexcube_log.id) end
    end

    test "change_flexcube_log/1 returns a flexcube_log changeset" do
      flexcube_log = flexcube_log_fixture()
      assert %Ecto.Changeset{} = FlexcubeLogs.change_flexcube_log(flexcube_log)
    end
  end
end
