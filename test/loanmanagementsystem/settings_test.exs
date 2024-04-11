defmodule Loanmanagementsystem.SettingsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Settings

  describe "tbl_config_settings" do
    alias Loanmanagementsystem.Settings.ConfigSettings

    import Loanmanagementsystem.SettingsFixtures

    @invalid_attrs %{deleted_at: nil, description: nil, name: nil, updated_by: nil, value: nil, value_type: nil}

    test "list_tbl_config_settings/0 returns all tbl_config_settings" do
      config_settings = config_settings_fixture()
      assert Settings.list_tbl_config_settings() == [config_settings]
    end

    test "get_config_settings!/1 returns the config_settings with given id" do
      config_settings = config_settings_fixture()
      assert Settings.get_config_settings!(config_settings.id) == config_settings
    end

    test "create_config_settings/1 with valid data creates a config_settings" do
      valid_attrs = %{deleted_at: ~N[2024-03-25 08:48:00], description: "some description", name: "some name", updated_by: "some updated_by", value: "some value", value_type: "some value_type"}

      assert {:ok, %ConfigSettings{} = config_settings} = Settings.create_config_settings(valid_attrs)
      assert config_settings.deleted_at == ~N[2024-03-25 08:48:00]
      assert config_settings.description == "some description"
      assert config_settings.name == "some name"
      assert config_settings.updated_by == "some updated_by"
      assert config_settings.value == "some value"
      assert config_settings.value_type == "some value_type"
    end

    test "create_config_settings/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_config_settings(@invalid_attrs)
    end

    test "update_config_settings/2 with valid data updates the config_settings" do
      config_settings = config_settings_fixture()
      update_attrs = %{deleted_at: ~N[2024-03-26 08:48:00], description: "some updated description", name: "some updated name", updated_by: "some updated updated_by", value: "some updated value", value_type: "some updated value_type"}

      assert {:ok, %ConfigSettings{} = config_settings} = Settings.update_config_settings(config_settings, update_attrs)
      assert config_settings.deleted_at == ~N[2024-03-26 08:48:00]
      assert config_settings.description == "some updated description"
      assert config_settings.name == "some updated name"
      assert config_settings.updated_by == "some updated updated_by"
      assert config_settings.value == "some updated value"
      assert config_settings.value_type == "some updated value_type"
    end

    test "update_config_settings/2 with invalid data returns error changeset" do
      config_settings = config_settings_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_config_settings(config_settings, @invalid_attrs)
      assert config_settings == Settings.get_config_settings!(config_settings.id)
    end

    test "delete_config_settings/1 deletes the config_settings" do
      config_settings = config_settings_fixture()
      assert {:ok, %ConfigSettings{}} = Settings.delete_config_settings(config_settings)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_config_settings!(config_settings.id) end
    end

    test "change_config_settings/1 returns a config_settings changeset" do
      config_settings = config_settings_fixture()
      assert %Ecto.Changeset{} = Settings.change_config_settings(config_settings)
    end
  end

  describe "tbl_notification_receivers" do
    alias Loanmanagementsystem.Settings.Receivers

    import Loanmanagementsystem.SettingsFixtures

    @invalid_attrs %{company: nil, email: nil, name: nil, status: nil}

    test "list_tbl_notification_receivers/0 returns all tbl_notification_receivers" do
      receivers = receivers_fixture()
      assert Settings.list_tbl_notification_receivers() == [receivers]
    end

    test "get_receivers!/1 returns the receivers with given id" do
      receivers = receivers_fixture()
      assert Settings.get_receivers!(receivers.id) == receivers
    end

    test "create_receivers/1 with valid data creates a receivers" do
      valid_attrs = %{company: "some company", email: "some email", name: "some name", status: "some status"}

      assert {:ok, %Receivers{} = receivers} = Settings.create_receivers(valid_attrs)
      assert receivers.company == "some company"
      assert receivers.email == "some email"
      assert receivers.name == "some name"
      assert receivers.status == "some status"
    end

    test "create_receivers/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_receivers(@invalid_attrs)
    end

    test "update_receivers/2 with valid data updates the receivers" do
      receivers = receivers_fixture()
      update_attrs = %{company: "some updated company", email: "some updated email", name: "some updated name", status: "some updated status"}

      assert {:ok, %Receivers{} = receivers} = Settings.update_receivers(receivers, update_attrs)
      assert receivers.company == "some updated company"
      assert receivers.email == "some updated email"
      assert receivers.name == "some updated name"
      assert receivers.status == "some updated status"
    end

    test "update_receivers/2 with invalid data returns error changeset" do
      receivers = receivers_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_receivers(receivers, @invalid_attrs)
      assert receivers == Settings.get_receivers!(receivers.id)
    end

    test "delete_receivers/1 deletes the receivers" do
      receivers = receivers_fixture()
      assert {:ok, %Receivers{}} = Settings.delete_receivers(receivers)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_receivers!(receivers.id) end
    end

    test "change_receivers/1 returns a receivers changeset" do
      receivers = receivers_fixture()
      assert %Ecto.Changeset{} = Settings.change_receivers(receivers)
    end
  end

  describe "tbl_sms_configuration" do
    alias Loanmanagementsystem.Settings.SmsConfigs

    import Loanmanagementsystem.SettingsFixtures

    @invalid_attrs %{host: nil, max_attempts: nil, password: nil, sender: nil, username: nil}

    test "list_tbl_sms_configuration/0 returns all tbl_sms_configuration" do
      sms_configs = sms_configs_fixture()
      assert Settings.list_tbl_sms_configuration() == [sms_configs]
    end

    test "get_sms_configs!/1 returns the sms_configs with given id" do
      sms_configs = sms_configs_fixture()
      assert Settings.get_sms_configs!(sms_configs.id) == sms_configs
    end

    test "create_sms_configs/1 with valid data creates a sms_configs" do
      valid_attrs = %{host: "some host", max_attempts: "some max_attempts", password: "some password", sender: "some sender", username: "some username"}

      assert {:ok, %SmsConfigs{} = sms_configs} = Settings.create_sms_configs(valid_attrs)
      assert sms_configs.host == "some host"
      assert sms_configs.max_attempts == "some max_attempts"
      assert sms_configs.password == "some password"
      assert sms_configs.sender == "some sender"
      assert sms_configs.username == "some username"
    end

    test "create_sms_configs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_sms_configs(@invalid_attrs)
    end

    test "update_sms_configs/2 with valid data updates the sms_configs" do
      sms_configs = sms_configs_fixture()
      update_attrs = %{host: "some updated host", max_attempts: "some updated max_attempts", password: "some updated password", sender: "some updated sender", username: "some updated username"}

      assert {:ok, %SmsConfigs{} = sms_configs} = Settings.update_sms_configs(sms_configs, update_attrs)
      assert sms_configs.host == "some updated host"
      assert sms_configs.max_attempts == "some updated max_attempts"
      assert sms_configs.password == "some updated password"
      assert sms_configs.sender == "some updated sender"
      assert sms_configs.username == "some updated username"
    end

    test "update_sms_configs/2 with invalid data returns error changeset" do
      sms_configs = sms_configs_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_sms_configs(sms_configs, @invalid_attrs)
      assert sms_configs == Settings.get_sms_configs!(sms_configs.id)
    end

    test "delete_sms_configs/1 deletes the sms_configs" do
      sms_configs = sms_configs_fixture()
      assert {:ok, %SmsConfigs{}} = Settings.delete_sms_configs(sms_configs)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_sms_configs!(sms_configs.id) end
    end

    test "change_sms_configs/1 returns a sms_configs changeset" do
      sms_configs = sms_configs_fixture()
      assert %Ecto.Changeset{} = Settings.change_sms_configs(sms_configs)
    end
  end
end
