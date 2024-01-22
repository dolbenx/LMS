defmodule Loanmanagementsystem.CustomersTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Customers

  describe "tbl_customer_balance" do
    alias Loanmanagementsystem.Customers.Customer

    @valid_attrs %{account_number: "some account_number", balance: 120.5, user_id: 42}
    @update_attrs %{account_number: "some updated account_number", balance: 456.7, user_id: 43}
    @invalid_attrs %{account_number: nil, balance: nil, user_id: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_customer()

      customer
    end

    test "list_tbl_customer_balance/0 returns all tbl_customer_balance" do
      customer = customer_fixture()
      assert Customers.list_tbl_customer_balance() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Customers.create_customer(@valid_attrs)
      assert customer.account_number == "some account_number"
      assert customer.balance == 120.5
      assert customer.user_id == 42
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, @update_attrs)
      assert customer.account_number == "some updated account_number"
      assert customer.balance == 456.7
      assert customer.user_id == 43
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end
end
