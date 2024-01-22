defmodule LoanSystem.AdminTest do
  use LoanSystem.DataCase

  alias LoanSystem.Admin

  describe "tbl_system_settings" do
    alias LoanSystem.Admin.SystemSettings

    @valid_attrs %{name: "some name", value: "some value"}
    @update_attrs %{name: "some updated name", value: "some updated value"}
    @invalid_attrs %{name: nil, value: nil}

    def system_settings_fixture(attrs \\ %{}) do
      {:ok, system_settings} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_system_settings()

      system_settings
    end

    test "list_tbl_system_settings/0 returns all tbl_system_settings" do
      system_settings = system_settings_fixture()
      assert Admin.list_tbl_system_settings() == [system_settings]
    end

    test "get_system_settings!/1 returns the system_settings with given id" do
      system_settings = system_settings_fixture()
      assert Admin.get_system_settings!(system_settings.id) == system_settings
    end

    test "create_system_settings/1 with valid data creates a system_settings" do
      assert {:ok, %SystemSettings{} = system_settings} = Admin.create_system_settings(@valid_attrs)
      assert system_settings.name == "some name"
      assert system_settings.value == "some value"
    end

    test "create_system_settings/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_system_settings(@invalid_attrs)
    end

    test "update_system_settings/2 with valid data updates the system_settings" do
      system_settings = system_settings_fixture()
      assert {:ok, %SystemSettings{} = system_settings} = Admin.update_system_settings(system_settings, @update_attrs)
      assert system_settings.name == "some updated name"
      assert system_settings.value == "some updated value"
    end

    test "update_system_settings/2 with invalid data returns error changeset" do
      system_settings = system_settings_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_system_settings(system_settings, @invalid_attrs)
      assert system_settings == Admin.get_system_settings!(system_settings.id)
    end

    test "delete_system_settings/1 deletes the system_settings" do
      system_settings = system_settings_fixture()
      assert {:ok, %SystemSettings{}} = Admin.delete_system_settings(system_settings)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_system_settings!(system_settings.id) end
    end

    test "change_system_settings/1 returns a system_settings changeset" do
      system_settings = system_settings_fixture()
      assert %Ecto.Changeset{} = Admin.change_system_settings(system_settings)
    end
  end
end
