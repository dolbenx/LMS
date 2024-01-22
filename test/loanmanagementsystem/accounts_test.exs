defmodule Loanmanagementsystem.AccountsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Accounts

  describe "tbl_address_details" do
    alias Loanmanagementsystem.Accounts.Address_Details

    @valid_attrs %{
      accomodation_status: "some accomodation_status",
      area: "some area",
      house_number: "some house_number",
      street_name: "some street_name",
      town: "some town",
      userId: "some userId",
      year_at_current_address: "some year_at_current_address"
    }
    @update_attrs %{
      accomodation_status: "some updated accomodation_status",
      area: "some updated area",
      house_number: "some updated house_number",
      street_name: "some updated street_name",
      town: "some updated town",
      userId: "some updated userId",
      year_at_current_address: "some updated year_at_current_address"
    }
    @invalid_attrs %{
      accomodation_status: nil,
      area: nil,
      house_number: nil,
      street_name: nil,
      town: nil,
      userId: nil,
      year_at_current_address: nil
    }

    def address__details_fixture(attrs \\ %{}) do
      {:ok, address__details} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_address__details()

      address__details
    end

    test "list_tbl_address_details/0 returns all tbl_address_details" do
      address__details = address__details_fixture()
      assert Accounts.list_tbl_address_details() == [address__details]
    end

    test "get_address__details!/1 returns the address__details with given id" do
      address__details = address__details_fixture()
      assert Accounts.get_address__details!(address__details.id) == address__details
    end

    test "create_address__details/1 with valid data creates a address__details" do
      assert {:ok, %Address_Details{} = address__details} =
               Accounts.create_address__details(@valid_attrs)

      assert address__details.accomodation_status == "some accomodation_status"
      assert address__details.area == "some area"
      assert address__details.house_number == "some house_number"
      assert address__details.street_name == "some street_name"
      assert address__details.town == "some town"
      assert address__details.userId == "some userId"
      assert address__details.year_at_current_address == "some year_at_current_address"
    end

    test "create_address__details/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_address__details(@invalid_attrs)
    end

    test "update_address__details/2 with valid data updates the address__details" do
      address__details = address__details_fixture()

      assert {:ok, %Address_Details{} = address__details} =
               Accounts.update_address__details(address__details, @update_attrs)

      assert address__details.accomodation_status == "some updated accomodation_status"
      assert address__details.area == "some updated area"
      assert address__details.house_number == "some updated house_number"
      assert address__details.street_name == "some updated street_name"
      assert address__details.town == "some updated town"
      assert address__details.userId == "some updated userId"
      assert address__details.year_at_current_address == "some updated year_at_current_address"
    end

    test "update_address__details/2 with invalid data returns error changeset" do
      address__details = address__details_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_address__details(address__details, @invalid_attrs)

      assert address__details == Accounts.get_address__details!(address__details.id)
    end

    test "delete_address__details/1 deletes the address__details" do
      address__details = address__details_fixture()
      assert {:ok, %Address_Details{}} = Accounts.delete_address__details(address__details)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_address__details!(address__details.id)
      end
    end

    test "change_address__details/1 returns a address__details changeset" do
      address__details = address__details_fixture()
      assert %Ecto.Changeset{} = Accounts.change_address__details(address__details)
    end
  end

  describe "tbl_address_details" do
    alias Loanmanagementsystem.Accounts.Address_Details

    @valid_attrs %{
      accomodation_status: "some accomodation_status",
      area: "some area",
      house_number: "some house_number",
      street_name: "some street_name",
      town: "some town",
      userId: 42,
      year_at_current_address: "some year_at_current_address"
    }
    @update_attrs %{
      accomodation_status: "some updated accomodation_status",
      area: "some updated area",
      house_number: "some updated house_number",
      street_name: "some updated street_name",
      town: "some updated town",
      userId: 43,
      year_at_current_address: "some updated year_at_current_address"
    }
    @invalid_attrs %{
      accomodation_status: nil,
      area: nil,
      house_number: nil,
      street_name: nil,
      town: nil,
      userId: nil,
      year_at_current_address: nil
    }

    def address__details_fixture(attrs \\ %{}) do
      {:ok, address__details} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_address__details()

      address__details
    end

    test "list_tbl_address_details/0 returns all tbl_address_details" do
      address__details = address__details_fixture()
      assert Accounts.list_tbl_address_details() == [address__details]
    end

    test "get_address__details!/1 returns the address__details with given id" do
      address__details = address__details_fixture()
      assert Accounts.get_address__details!(address__details.id) == address__details
    end

    test "create_address__details/1 with valid data creates a address__details" do
      assert {:ok, %Address_Details{} = address__details} =
               Accounts.create_address__details(@valid_attrs)

      assert address__details.accomodation_status == "some accomodation_status"
      assert address__details.area == "some area"
      assert address__details.house_number == "some house_number"
      assert address__details.street_name == "some street_name"
      assert address__details.town == "some town"
      assert address__details.userId == 42
      assert address__details.year_at_current_address == "some year_at_current_address"
    end

    test "create_address__details/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_address__details(@invalid_attrs)
    end

    test "update_address__details/2 with valid data updates the address__details" do
      address__details = address__details_fixture()

      assert {:ok, %Address_Details{} = address__details} =
               Accounts.update_address__details(address__details, @update_attrs)

      assert address__details.accomodation_status == "some updated accomodation_status"
      assert address__details.area == "some updated area"
      assert address__details.house_number == "some updated house_number"
      assert address__details.street_name == "some updated street_name"
      assert address__details.town == "some updated town"
      assert address__details.userId == 43
      assert address__details.year_at_current_address == "some updated year_at_current_address"
    end

    test "update_address__details/2 with invalid data returns error changeset" do
      address__details = address__details_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_address__details(address__details, @invalid_attrs)

      assert address__details == Accounts.get_address__details!(address__details.id)
    end

    test "delete_address__details/1 deletes the address__details" do
      address__details = address__details_fixture()
      assert {:ok, %Address_Details{}} = Accounts.delete_address__details(address__details)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_address__details!(address__details.id)
      end
    end

    test "change_address__details/1 returns a address__details changeset" do
      address__details = address__details_fixture()
      assert %Ecto.Changeset{} = Accounts.change_address__details(address__details)
    end
  end

  describe "tbl_role_description" do
    alias Loanmanagementsystem.Accounts.RoleDescription

    @valid_attrs %{Role_Id: 42, Role_description: "some Role_description", User_Id: 42}
    @update_attrs %{Role_Id: 43, Role_description: "some updated Role_description", User_Id: 43}
    @invalid_attrs %{Role_Id: nil, Role_description: nil, User_Id: nil}

    def role_description_fixture(attrs \\ %{}) do
      {:ok, role_description} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_role_description()

      role_description
    end

    test "list_tbl_role_description/0 returns all tbl_role_description" do
      role_description = role_description_fixture()
      assert Accounts.list_tbl_role_description() == [role_description]
    end

    test "get_role_description!/1 returns the role_description with given id" do
      role_description = role_description_fixture()
      assert Accounts.get_role_description!(role_description.id) == role_description
    end

    test "create_role_description/1 with valid data creates a role_description" do
      assert {:ok, %RoleDescription{} = role_description} =
               Accounts.create_role_description(@valid_attrs)

      assert role_description.Role_Id == 42
      assert role_description.Role_description == "some Role_description"
      assert role_description.User_Id == 42
    end

    test "create_role_description/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role_description(@invalid_attrs)
    end

    test "update_role_description/2 with valid data updates the role_description" do
      role_description = role_description_fixture()

      assert {:ok, %RoleDescription{} = role_description} =
               Accounts.update_role_description(role_description, @update_attrs)

      assert role_description.Role_Id == 43
      assert role_description.Role_description == "some updated Role_description"
      assert role_description.User_Id == 43
    end

    test "update_role_description/2 with invalid data returns error changeset" do
      role_description = role_description_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_role_description(role_description, @invalid_attrs)

      assert role_description == Accounts.get_role_description!(role_description.id)
    end

    test "delete_role_description/1 deletes the role_description" do
      role_description = role_description_fixture()
      assert {:ok, %RoleDescription{}} = Accounts.delete_role_description(role_description)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_role_description!(role_description.id)
      end
    end

    test "change_role_description/1 returns a role_description changeset" do
      role_description = role_description_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role_description(role_description)
    end
  end

  describe "tbl_customer_accounts" do
    alias Loanmanagementsystem.Accounts.Customer_account

    @valid_attrs %{account_number: "some account_number", status: "some status", user_id: 42}
    @update_attrs %{
      account_number: "some updated account_number",
      status: "some updated status",
      user_id: 43
    }
    @invalid_attrs %{account_number: nil, status: nil, user_id: nil}

    def customer_account_fixture(attrs \\ %{}) do
      {:ok, customer_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_customer_account()

      customer_account
    end

    test "list_tbl_customer_accounts/0 returns all tbl_customer_accounts" do
      customer_account = customer_account_fixture()
      assert Accounts.list_tbl_customer_accounts() == [customer_account]
    end

    test "get_customer_account!/1 returns the customer_account with given id" do
      customer_account = customer_account_fixture()
      assert Accounts.get_customer_account!(customer_account.id) == customer_account
    end

    test "create_customer_account/1 with valid data creates a customer_account" do
      assert {:ok, %Customer_account{} = customer_account} =
               Accounts.create_customer_account(@valid_attrs)

      assert customer_account.account_number == "some account_number"
      assert customer_account.status == "some status"
      assert customer_account.user_id == 42
    end

    test "create_customer_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_customer_account(@invalid_attrs)
    end

    test "update_customer_account/2 with valid data updates the customer_account" do
      customer_account = customer_account_fixture()

      assert {:ok, %Customer_account{} = customer_account} =
               Accounts.update_customer_account(customer_account, @update_attrs)

      assert customer_account.account_number == "some updated account_number"
      assert customer_account.status == "some updated status"
      assert customer_account.user_id == 43
    end

    test "update_customer_account/2 with invalid data returns error changeset" do
      customer_account = customer_account_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_customer_account(customer_account, @invalid_attrs)

      assert customer_account == Accounts.get_customer_account!(customer_account.id)
    end

    test "delete_customer_account/1 deletes the customer_account" do
      customer_account = customer_account_fixture()
      assert {:ok, %Customer_account{}} = Accounts.delete_customer_account(customer_account)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_customer_account!(customer_account.id)
      end
    end

    test "change_customer_account/1 returns a customer_account changeset" do
      customer_account = customer_account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_customer_account(customer_account)
    end
  end
end
