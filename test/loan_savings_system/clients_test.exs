defmodule LoanSavingsSystem.ClientsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Clients

  describe "tbl_clients" do
    alias LoanSavingsSystem.Clients.Client

    @valid_attrs %{account_creation_endpoint: "some account_creation_endpoint", balance_inquiry_endpoint: "some balance_inquiry_endpoint", client_bank_id: "some client_bank_id", client_name: "some client_name", country_code: "some country_code", country_name: "some country_name", funds_transfer_endpoint: "some funds_transfer_endpoint", is_bank: "some is_bank", is_domicile_transaction_records_at_client: "some is_domicile_transaction_records_at_client", status: "some status"}
    @update_attrs %{account_creation_endpoint: "some updated account_creation_endpoint", balance_inquiry_endpoint: "some updated balance_inquiry_endpoint", client_bank_id: "some updated client_bank_id", client_name: "some updated client_name", country_code: "some updated country_code", country_name: "some updated country_name", funds_transfer_endpoint: "some updated funds_transfer_endpoint", is_bank: "some updated is_bank", is_domicile_transaction_records_at_client: "some updated is_domicile_transaction_records_at_client", status: "some updated status"}
    @invalid_attrs %{account_creation_endpoint: nil, balance_inquiry_endpoint: nil, client_bank_id: nil, client_name: nil, country_code: nil, country_name: nil, funds_transfer_endpoint: nil, is_bank: nil, is_domicile_transaction_records_at_client: nil, status: nil}

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clients.create_client()

      client
    end

    test "list_tbl_clients/0 returns all tbl_clients" do
      client = client_fixture()
      assert Clients.list_tbl_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Clients.create_client(@valid_attrs)
      assert client.account_creation_endpoint == "some account_creation_endpoint"
      assert client.balance_inquiry_endpoint == "some balance_inquiry_endpoint"
      assert client.client_bank_id == "some client_bank_id"
      assert client.client_name == "some client_name"
      assert client.country_code == "some country_code"
      assert client.country_name == "some country_name"
      assert client.funds_transfer_endpoint == "some funds_transfer_endpoint"
      assert client.is_bank == "some is_bank"
      assert client.is_domicile_transaction_records_at_client == "some is_domicile_transaction_records_at_client"
      assert client.status == "some status"
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, %Client{} = client} = Clients.update_client(client, @update_attrs)
      assert client.account_creation_endpoint == "some updated account_creation_endpoint"
      assert client.balance_inquiry_endpoint == "some updated balance_inquiry_endpoint"
      assert client.client_bank_id == "some updated client_bank_id"
      assert client.client_name == "some updated client_name"
      assert client.country_code == "some updated country_code"
      assert client.country_name == "some updated country_name"
      assert client.funds_transfer_endpoint == "some updated funds_transfer_endpoint"
      assert client.is_bank == "some updated is_bank"
      assert client.is_domicile_transaction_records_at_client == "some updated is_domicile_transaction_records_at_client"
      assert client.status == "some updated status"
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end
  end

  describe "tbl_client_telco" do
    alias LoanSavingsSystem.Clients.Client_telco

    @valid_attrs %{client_id: "some client_id", telco_id: "some telco_id", ussd_short_code: "some ussd_short_code"}
    @update_attrs %{client_id: "some updated client_id", telco_id: "some updated telco_id", ussd_short_code: "some updated ussd_short_code"}
    @invalid_attrs %{client_id: nil, telco_id: nil, ussd_short_code: nil}

    def client_telco_fixture(attrs \\ %{}) do
      {:ok, client_telco} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clients.create_client_telco()

      client_telco
    end

    test "list_tbl_client_telco/0 returns all tbl_client_telco" do
      client_telco = client_telco_fixture()
      assert Clients.list_tbl_client_telco() == [client_telco]
    end

    test "get_client_telco!/1 returns the client_telco with given id" do
      client_telco = client_telco_fixture()
      assert Clients.get_client_telco!(client_telco.id) == client_telco
    end

    test "create_client_telco/1 with valid data creates a client_telco" do
      assert {:ok, %Client_telco{} = client_telco} = Clients.create_client_telco(@valid_attrs)
      assert client_telco.client_id == "some client_id"
      assert client_telco.telco_id == "some telco_id"
      assert client_telco.ussd_short_code == "some ussd_short_code"
    end

    test "create_client_telco/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client_telco(@invalid_attrs)
    end

    test "update_client_telco/2 with valid data updates the client_telco" do
      client_telco = client_telco_fixture()
      assert {:ok, %Client_telco{} = client_telco} = Clients.update_client_telco(client_telco, @update_attrs)
      assert client_telco.client_id == "some updated client_id"
      assert client_telco.telco_id == "some updated telco_id"
      assert client_telco.ussd_short_code == "some updated ussd_short_code"
    end

    test "update_client_telco/2 with invalid data returns error changeset" do
      client_telco = client_telco_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client_telco(client_telco, @invalid_attrs)
      assert client_telco == Clients.get_client_telco!(client_telco.id)
    end

    test "delete_client_telco/1 deletes the client_telco" do
      client_telco = client_telco_fixture()
      assert {:ok, %Client_telco{}} = Clients.delete_client_telco(client_telco)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client_telco!(client_telco.id) end
    end

    test "change_client_telco/1 returns a client_telco changeset" do
      client_telco = client_telco_fixture()
      assert %Ecto.Changeset{} = Clients.change_client_telco(client_telco)
    end
  end
end
