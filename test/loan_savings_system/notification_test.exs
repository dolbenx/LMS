defmodule LoanSavingsSystem.NotificationTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Notification

  describe "tbl_sms_notification_configuration" do
    alias LoanSavingsSystem.Notification.SmsNotificationConfiguration

    @valid_attrs %{actionType: "some actionType", days: 42, interval: 42, intervaltype: "some intervaltype", message: "some message", numberOfSms: 42}
    @update_attrs %{actionType: "some updated actionType", days: 43, interval: 43, intervaltype: "some updated intervaltype", message: "some updated message", numberOfSms: 43}
    @invalid_attrs %{actionType: nil, days: nil, interval: nil, intervaltype: nil, message: nil, numberOfSms: nil}

    def sms_notification_configuration_fixture(attrs \\ %{}) do
      {:ok, sms_notification_configuration} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notification.create_sms_notification_configuration()

      sms_notification_configuration
    end

    test "list_tbl_sms_notification_configuration/0 returns all tbl_sms_notification_configuration" do
      sms_notification_configuration = sms_notification_configuration_fixture()
      assert Notification.list_tbl_sms_notification_configuration() == [sms_notification_configuration]
    end

    test "get_sms_notification_configuration!/1 returns the sms_notification_configuration with given id" do
      sms_notification_configuration = sms_notification_configuration_fixture()
      assert Notification.get_sms_notification_configuration!(sms_notification_configuration.id) == sms_notification_configuration
    end

    test "create_sms_notification_configuration/1 with valid data creates a sms_notification_configuration" do
      assert {:ok, %SmsNotificationConfiguration{} = sms_notification_configuration} = Notification.create_sms_notification_configuration(@valid_attrs)
      assert sms_notification_configuration.actionType == "some actionType"
      assert sms_notification_configuration.days == 42
      assert sms_notification_configuration.interval == 42
      assert sms_notification_configuration.intervaltype == "some intervaltype"
      assert sms_notification_configuration.message == "some message"
      assert sms_notification_configuration.numberOfSms == 42
    end

    test "create_sms_notification_configuration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notification.create_sms_notification_configuration(@invalid_attrs)
    end

    test "update_sms_notification_configuration/2 with valid data updates the sms_notification_configuration" do
      sms_notification_configuration = sms_notification_configuration_fixture()
      assert {:ok, %SmsNotificationConfiguration{} = sms_notification_configuration} = Notification.update_sms_notification_configuration(sms_notification_configuration, @update_attrs)
      assert sms_notification_configuration.actionType == "some updated actionType"
      assert sms_notification_configuration.days == 43
      assert sms_notification_configuration.interval == 43
      assert sms_notification_configuration.intervaltype == "some updated intervaltype"
      assert sms_notification_configuration.message == "some updated message"
      assert sms_notification_configuration.numberOfSms == 43
    end

    test "update_sms_notification_configuration/2 with invalid data returns error changeset" do
      sms_notification_configuration = sms_notification_configuration_fixture()
      assert {:error, %Ecto.Changeset{}} = Notification.update_sms_notification_configuration(sms_notification_configuration, @invalid_attrs)
      assert sms_notification_configuration == Notification.get_sms_notification_configuration!(sms_notification_configuration.id)
    end

    test "delete_sms_notification_configuration/1 deletes the sms_notification_configuration" do
      sms_notification_configuration = sms_notification_configuration_fixture()
      assert {:ok, %SmsNotificationConfiguration{}} = Notification.delete_sms_notification_configuration(sms_notification_configuration)
      assert_raise Ecto.NoResultsError, fn -> Notification.get_sms_notification_configuration!(sms_notification_configuration.id) end
    end

    test "change_sms_notification_configuration/1 returns a sms_notification_configuration changeset" do
      sms_notification_configuration = sms_notification_configuration_fixture()
      assert %Ecto.Changeset{} = Notification.change_sms_notification_configuration(sms_notification_configuration)
    end
  end
end
