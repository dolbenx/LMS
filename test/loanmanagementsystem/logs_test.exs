defmodule Loanmanagementsystem.LogsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Logs

  describe "tbl_user_logs" do
    alias Loanmanagementsystem.Logs.UserLogs

    import Loanmanagementsystem.LogsFixtures

    @invalid_attrs %{activity: nil, user_id: nil}

    test "list_tbl_user_logs/0 returns all tbl_user_logs" do
      user_logs = user_logs_fixture()
      assert Logs.list_tbl_user_logs() == [user_logs]
    end

    test "get_user_logs!/1 returns the user_logs with given id" do
      user_logs = user_logs_fixture()
      assert Logs.get_user_logs!(user_logs.id) == user_logs
    end

    test "create_user_logs/1 with valid data creates a user_logs" do
      valid_attrs = %{activity: "some activity", user_id: 42}

      assert {:ok, %UserLogs{} = user_logs} = Logs.create_user_logs(valid_attrs)
      assert user_logs.activity == "some activity"
      assert user_logs.user_id == 42
    end

    test "create_user_logs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_user_logs(@invalid_attrs)
    end

    test "update_user_logs/2 with valid data updates the user_logs" do
      user_logs = user_logs_fixture()
      update_attrs = %{activity: "some updated activity", user_id: 43}

      assert {:ok, %UserLogs{} = user_logs} = Logs.update_user_logs(user_logs, update_attrs)
      assert user_logs.activity == "some updated activity"
      assert user_logs.user_id == 43
    end

    test "update_user_logs/2 with invalid data returns error changeset" do
      user_logs = user_logs_fixture()
      assert {:error, %Ecto.Changeset{}} = Logs.update_user_logs(user_logs, @invalid_attrs)
      assert user_logs == Logs.get_user_logs!(user_logs.id)
    end

    test "delete_user_logs/1 deletes the user_logs" do
      user_logs = user_logs_fixture()
      assert {:ok, %UserLogs{}} = Logs.delete_user_logs(user_logs)
      assert_raise Ecto.NoResultsError, fn -> Logs.get_user_logs!(user_logs.id) end
    end

    test "change_user_logs/1 returns a user_logs changeset" do
      user_logs = user_logs_fixture()
      assert %Ecto.Changeset{} = Logs.change_user_logs(user_logs)
    end
  end

  describe "tbl_session_logs" do
    alias Loanmanagementsystem.Logs.SessionLogs

    import Loanmanagementsystem.LogsFixtures

    @invalid_attrs %{browser_details: nil, description: nil, device_type: nil, device_uuid: nil, full_browser_name: nil, ip_address: nil, known_browser: nil, portal: nil, session_id: nil, status: nil, system_platform_name: nil}

    test "list_tbl_session_logs/0 returns all tbl_session_logs" do
      session_logs = session_logs_fixture()
      assert Logs.list_tbl_session_logs() == [session_logs]
    end

    test "get_session_logs!/1 returns the session_logs with given id" do
      session_logs = session_logs_fixture()
      assert Logs.get_session_logs!(session_logs.id) == session_logs
    end

    test "create_session_logs/1 with valid data creates a session_logs" do
      valid_attrs = %{browser_details: "some browser_details", description: "some description", device_type: "some device_type", device_uuid: "some device_uuid", full_browser_name: "some full_browser_name", ip_address: "some ip_address", known_browser: true, portal: "some portal", session_id: "some session_id", status: true, system_platform_name: "some system_platform_name"}

      assert {:ok, %SessionLogs{} = session_logs} = Logs.create_session_logs(valid_attrs)
      assert session_logs.browser_details == "some browser_details"
      assert session_logs.description == "some description"
      assert session_logs.device_type == "some device_type"
      assert session_logs.device_uuid == "some device_uuid"
      assert session_logs.full_browser_name == "some full_browser_name"
      assert session_logs.ip_address == "some ip_address"
      assert session_logs.known_browser == true
      assert session_logs.portal == "some portal"
      assert session_logs.session_id == "some session_id"
      assert session_logs.status == true
      assert session_logs.system_platform_name == "some system_platform_name"
    end

    test "create_session_logs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_session_logs(@invalid_attrs)
    end

    test "update_session_logs/2 with valid data updates the session_logs" do
      session_logs = session_logs_fixture()
      update_attrs = %{browser_details: "some updated browser_details", description: "some updated description", device_type: "some updated device_type", device_uuid: "some updated device_uuid", full_browser_name: "some updated full_browser_name", ip_address: "some updated ip_address", known_browser: false, portal: "some updated portal", session_id: "some updated session_id", status: false, system_platform_name: "some updated system_platform_name"}

      assert {:ok, %SessionLogs{} = session_logs} = Logs.update_session_logs(session_logs, update_attrs)
      assert session_logs.browser_details == "some updated browser_details"
      assert session_logs.description == "some updated description"
      assert session_logs.device_type == "some updated device_type"
      assert session_logs.device_uuid == "some updated device_uuid"
      assert session_logs.full_browser_name == "some updated full_browser_name"
      assert session_logs.ip_address == "some updated ip_address"
      assert session_logs.known_browser == false
      assert session_logs.portal == "some updated portal"
      assert session_logs.session_id == "some updated session_id"
      assert session_logs.status == false
      assert session_logs.system_platform_name == "some updated system_platform_name"
    end

    test "update_session_logs/2 with invalid data returns error changeset" do
      session_logs = session_logs_fixture()
      assert {:error, %Ecto.Changeset{}} = Logs.update_session_logs(session_logs, @invalid_attrs)
      assert session_logs == Logs.get_session_logs!(session_logs.id)
    end

    test "delete_session_logs/1 deletes the session_logs" do
      session_logs = session_logs_fixture()
      assert {:ok, %SessionLogs{}} = Logs.delete_session_logs(session_logs)
      assert_raise Ecto.NoResultsError, fn -> Logs.get_session_logs!(session_logs.id) end
    end

    test "change_session_logs/1 returns a session_logs changeset" do
      session_logs = session_logs_fixture()
      assert %Ecto.Changeset{} = Logs.change_session_logs(session_logs)
    end
  end
end
