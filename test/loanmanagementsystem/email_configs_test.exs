defmodule Loanmanagementsystem.Email_configsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Email_configs

  describe "tbl_email_sender" do
    alias Loanmanagementsystem.Email_configs.Email_config

    @valid_attrs %{email: "some email", password: "some password", status: "some status"}
    @update_attrs %{email: "some updated email", password: "some updated password", status: "some updated status"}
    @invalid_attrs %{email: nil, password: nil, status: nil}

    def email_config_fixture(attrs \\ %{}) do
      {:ok, email_config} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Email_configs.create_email_config()

      email_config
    end

    test "list_tbl_email_sender/0 returns all tbl_email_sender" do
      email_config = email_config_fixture()
      assert Email_configs.list_tbl_email_sender() == [email_config]
    end

    test "get_email_config!/1 returns the email_config with given id" do
      email_config = email_config_fixture()
      assert Email_configs.get_email_config!(email_config.id) == email_config
    end

    test "create_email_config/1 with valid data creates a email_config" do
      assert {:ok, %Email_config{} = email_config} = Email_configs.create_email_config(@valid_attrs)
      assert email_config.email == "some email"
      assert email_config.password == "some password"
      assert email_config.status == "some status"
    end

    test "create_email_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Email_configs.create_email_config(@invalid_attrs)
    end

    test "update_email_config/2 with valid data updates the email_config" do
      email_config = email_config_fixture()
      assert {:ok, %Email_config{} = email_config} = Email_configs.update_email_config(email_config, @update_attrs)
      assert email_config.email == "some updated email"
      assert email_config.password == "some updated password"
      assert email_config.status == "some updated status"
    end

    test "update_email_config/2 with invalid data returns error changeset" do
      email_config = email_config_fixture()
      assert {:error, %Ecto.Changeset{}} = Email_configs.update_email_config(email_config, @invalid_attrs)
      assert email_config == Email_configs.get_email_config!(email_config.id)
    end

    test "delete_email_config/1 deletes the email_config" do
      email_config = email_config_fixture()
      assert {:ok, %Email_config{}} = Email_configs.delete_email_config(email_config)
      assert_raise Ecto.NoResultsError, fn -> Email_configs.get_email_config!(email_config.id) end
    end

    test "change_email_config/1 returns a email_config changeset" do
      email_config = email_config_fixture()
      assert %Ecto.Changeset{} = Email_configs.change_email_config(email_config)
    end
  end

  describe "tbl_email_receiver" do
    alias Loanmanagementsystem.Email_configs.Email_config

    @valid_attrs %{email: "some email", name: "some name", status: "some status"}
    @update_attrs %{email: "some updated email", name: "some updated name", status: "some updated status"}
    @invalid_attrs %{email: nil, name: nil, status: nil}

    def email_config_fixture(attrs \\ %{}) do
      {:ok, email_config} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Email_configs.create_email_config()

      email_config
    end

    test "list_tbl_email_receiver/0 returns all tbl_email_receiver" do
      email_config = email_config_fixture()
      assert Email_configs.list_tbl_email_receiver() == [email_config]
    end

    test "get_email_config!/1 returns the email_config with given id" do
      email_config = email_config_fixture()
      assert Email_configs.get_email_config!(email_config.id) == email_config
    end

    test "create_email_config/1 with valid data creates a email_config" do
      assert {:ok, %Email_config{} = email_config} = Email_configs.create_email_config(@valid_attrs)
      assert email_config.email == "some email"
      assert email_config.name == "some name"
      assert email_config.status == "some status"
    end

    test "create_email_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Email_configs.create_email_config(@invalid_attrs)
    end

    test "update_email_config/2 with valid data updates the email_config" do
      email_config = email_config_fixture()
      assert {:ok, %Email_config{} = email_config} = Email_configs.update_email_config(email_config, @update_attrs)
      assert email_config.email == "some updated email"
      assert email_config.name == "some updated name"
      assert email_config.status == "some updated status"
    end

    test "update_email_config/2 with invalid data returns error changeset" do
      email_config = email_config_fixture()
      assert {:error, %Ecto.Changeset{}} = Email_configs.update_email_config(email_config, @invalid_attrs)
      assert email_config == Email_configs.get_email_config!(email_config.id)
    end

    test "delete_email_config/1 deletes the email_config" do
      email_config = email_config_fixture()
      assert {:ok, %Email_config{}} = Email_configs.delete_email_config(email_config)
      assert_raise Ecto.NoResultsError, fn -> Email_configs.get_email_config!(email_config.id) end
    end

    test "change_email_config/1 returns a email_config changeset" do
      email_config = email_config_fixture()
      assert %Ecto.Changeset{} = Email_configs.change_email_config(email_config)
    end
  end

  describe "tbl_email_sender" do
    alias Loanmanagementsystem.Email_configs.Email_config_sender

    @valid_attrs %{email: "some email", password: "some password", status: "some status"}
    @update_attrs %{email: "some updated email", password: "some updated password", status: "some updated status"}
    @invalid_attrs %{email: nil, password: nil, status: nil}

    def email_config_sender_fixture(attrs \\ %{}) do
      {:ok, email_config_sender} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Email_configs.create_email_config_sender()

      email_config_sender
    end

    test "list_tbl_email_sender/0 returns all tbl_email_sender" do
      email_config_sender = email_config_sender_fixture()
      assert Email_configs.list_tbl_email_sender() == [email_config_sender]
    end

    test "get_email_config_sender!/1 returns the email_config_sender with given id" do
      email_config_sender = email_config_sender_fixture()
      assert Email_configs.get_email_config_sender!(email_config_sender.id) == email_config_sender
    end

    test "create_email_config_sender/1 with valid data creates a email_config_sender" do
      assert {:ok, %Email_config_sender{} = email_config_sender} = Email_configs.create_email_config_sender(@valid_attrs)
      assert email_config_sender.email == "some email"
      assert email_config_sender.password == "some password"
      assert email_config_sender.status == "some status"
    end

    test "create_email_config_sender/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Email_configs.create_email_config_sender(@invalid_attrs)
    end

    test "update_email_config_sender/2 with valid data updates the email_config_sender" do
      email_config_sender = email_config_sender_fixture()
      assert {:ok, %Email_config_sender{} = email_config_sender} = Email_configs.update_email_config_sender(email_config_sender, @update_attrs)
      assert email_config_sender.email == "some updated email"
      assert email_config_sender.password == "some updated password"
      assert email_config_sender.status == "some updated status"
    end

    test "update_email_config_sender/2 with invalid data returns error changeset" do
      email_config_sender = email_config_sender_fixture()
      assert {:error, %Ecto.Changeset{}} = Email_configs.update_email_config_sender(email_config_sender, @invalid_attrs)
      assert email_config_sender == Email_configs.get_email_config_sender!(email_config_sender.id)
    end

    test "delete_email_config_sender/1 deletes the email_config_sender" do
      email_config_sender = email_config_sender_fixture()
      assert {:ok, %Email_config_sender{}} = Email_configs.delete_email_config_sender(email_config_sender)
      assert_raise Ecto.NoResultsError, fn -> Email_configs.get_email_config_sender!(email_config_sender.id) end
    end

    test "change_email_config_sender/1 returns a email_config_sender changeset" do
      email_config_sender = email_config_sender_fixture()
      assert %Ecto.Changeset{} = Email_configs.change_email_config_sender(email_config_sender)
    end
  end

  describe "tbl_email_receiver" do
    alias Loanmanagementsystem.Email_configs.Email_config_receiver

    @valid_attrs %{email: "some email", name: "some name", status: "some status"}
    @update_attrs %{email: "some updated email", name: "some updated name", status: "some updated status"}
    @invalid_attrs %{email: nil, name: nil, status: nil}

    def email_config_receiver_fixture(attrs \\ %{}) do
      {:ok, email_config_receiver} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Email_configs.create_email_config_receiver()

      email_config_receiver
    end

    test "list_tbl_email_receiver/0 returns all tbl_email_receiver" do
      email_config_receiver = email_config_receiver_fixture()
      assert Email_configs.list_tbl_email_receiver() == [email_config_receiver]
    end

    test "get_email_config_receiver!/1 returns the email_config_receiver with given id" do
      email_config_receiver = email_config_receiver_fixture()
      assert Email_configs.get_email_config_receiver!(email_config_receiver.id) == email_config_receiver
    end

    test "create_email_config_receiver/1 with valid data creates a email_config_receiver" do
      assert {:ok, %Email_config_receiver{} = email_config_receiver} = Email_configs.create_email_config_receiver(@valid_attrs)
      assert email_config_receiver.email == "some email"
      assert email_config_receiver.name == "some name"
      assert email_config_receiver.status == "some status"
    end

    test "create_email_config_receiver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Email_configs.create_email_config_receiver(@invalid_attrs)
    end

    test "update_email_config_receiver/2 with valid data updates the email_config_receiver" do
      email_config_receiver = email_config_receiver_fixture()
      assert {:ok, %Email_config_receiver{} = email_config_receiver} = Email_configs.update_email_config_receiver(email_config_receiver, @update_attrs)
      assert email_config_receiver.email == "some updated email"
      assert email_config_receiver.name == "some updated name"
      assert email_config_receiver.status == "some updated status"
    end

    test "update_email_config_receiver/2 with invalid data returns error changeset" do
      email_config_receiver = email_config_receiver_fixture()
      assert {:error, %Ecto.Changeset{}} = Email_configs.update_email_config_receiver(email_config_receiver, @invalid_attrs)
      assert email_config_receiver == Email_configs.get_email_config_receiver!(email_config_receiver.id)
    end

    test "delete_email_config_receiver/1 deletes the email_config_receiver" do
      email_config_receiver = email_config_receiver_fixture()
      assert {:ok, %Email_config_receiver{}} = Email_configs.delete_email_config_receiver(email_config_receiver)
      assert_raise Ecto.NoResultsError, fn -> Email_configs.get_email_config_receiver!(email_config_receiver.id) end
    end

    test "change_email_config_receiver/1 returns a email_config_receiver changeset" do
      email_config_receiver = email_config_receiver_fixture()
      assert %Ecto.Changeset{} = Email_configs.change_email_config_receiver(email_config_receiver)
    end
  end
end
