defmodule Loanmanagementsystem.AlertsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Alerts

  describe "tbl_alert_templete" do
    alias Loanmanagementsystem.Alerts.Alert

    @valid_attrs %{
      alert_message: "some alert_message",
      alert_type: "some alert_type",
      status: "some status"
    }
    @update_attrs %{
      alert_message: "some updated alert_message",
      alert_type: "some updated alert_type",
      status: "some updated status"
    }
    @invalid_attrs %{alert_message: nil, alert_type: nil, status: nil}

    def alert_fixture(attrs \\ %{}) do
      {:ok, alert} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Alerts.create_alert()

      alert
    end

    test "list_tbl_alert_templete/0 returns all tbl_alert_templete" do
      alert = alert_fixture()
      assert Alerts.list_tbl_alert_templete() == [alert]
    end

    test "get_alert!/1 returns the alert with given id" do
      alert = alert_fixture()
      assert Alerts.get_alert!(alert.id) == alert
    end

    test "create_alert/1 with valid data creates a alert" do
      assert {:ok, %Alert{} = alert} = Alerts.create_alert(@valid_attrs)
      assert alert.alert_message == "some alert_message"
      assert alert.alert_type == "some alert_type"
      assert alert.status == "some status"
    end

    test "create_alert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Alerts.create_alert(@invalid_attrs)
    end

    test "update_alert/2 with valid data updates the alert" do
      alert = alert_fixture()
      assert {:ok, %Alert{} = alert} = Alerts.update_alert(alert, @update_attrs)
      assert alert.alert_message == "some updated alert_message"
      assert alert.alert_type == "some updated alert_type"
      assert alert.status == "some updated status"
    end

    test "update_alert/2 with invalid data returns error changeset" do
      alert = alert_fixture()
      assert {:error, %Ecto.Changeset{}} = Alerts.update_alert(alert, @invalid_attrs)
      assert alert == Alerts.get_alert!(alert.id)
    end

    test "delete_alert/1 deletes the alert" do
      alert = alert_fixture()
      assert {:ok, %Alert{}} = Alerts.delete_alert(alert)
      assert_raise Ecto.NoResultsError, fn -> Alerts.get_alert!(alert.id) end
    end

    test "change_alert/1 returns a alert changeset" do
      alert = alert_fixture()
      assert %Ecto.Changeset{} = Alerts.change_alert(alert)
    end
  end
end
