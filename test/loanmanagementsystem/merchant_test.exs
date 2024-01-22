defmodule Loanmanagementsystem.MerchantTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Merchant

  describe "tbl_merchant_account" do
    alias Loanmanagementsystem.Merchant.Merchant_account

    @valid_attrs %{balance: 120.5, merchant_id: 42, merchant_number: "some merchant_number", status: "some status"}
    @update_attrs %{balance: 456.7, merchant_id: 43, merchant_number: "some updated merchant_number", status: "some updated status"}
    @invalid_attrs %{balance: nil, merchant_id: nil, merchant_number: nil, status: nil}

    def merchant_account_fixture(attrs \\ %{}) do
      {:ok, merchant_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchant.create_merchant_account()

      merchant_account
    end

    test "list_tbl_merchant_account/0 returns all tbl_merchant_account" do
      merchant_account = merchant_account_fixture()
      assert Merchant.list_tbl_merchant_account() == [merchant_account]
    end

    test "get_merchant_account!/1 returns the merchant_account with given id" do
      merchant_account = merchant_account_fixture()
      assert Merchant.get_merchant_account!(merchant_account.id) == merchant_account
    end

    test "create_merchant_account/1 with valid data creates a merchant_account" do
      assert {:ok, %Merchant_account{} = merchant_account} = Merchant.create_merchant_account(@valid_attrs)
      assert merchant_account.balance == 120.5
      assert merchant_account.merchant_id == 42
      assert merchant_account.merchant_number == "some merchant_number"
      assert merchant_account.status == "some status"
    end

    test "create_merchant_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchant.create_merchant_account(@invalid_attrs)
    end

    test "update_merchant_account/2 with valid data updates the merchant_account" do
      merchant_account = merchant_account_fixture()
      assert {:ok, %Merchant_account{} = merchant_account} = Merchant.update_merchant_account(merchant_account, @update_attrs)
      assert merchant_account.balance == 456.7
      assert merchant_account.merchant_id == 43
      assert merchant_account.merchant_number == "some updated merchant_number"
      assert merchant_account.status == "some updated status"
    end

    test "update_merchant_account/2 with invalid data returns error changeset" do
      merchant_account = merchant_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Merchant.update_merchant_account(merchant_account, @invalid_attrs)
      assert merchant_account == Merchant.get_merchant_account!(merchant_account.id)
    end

    test "delete_merchant_account/1 deletes the merchant_account" do
      merchant_account = merchant_account_fixture()
      assert {:ok, %Merchant_account{}} = Merchant.delete_merchant_account(merchant_account)
      assert_raise Ecto.NoResultsError, fn -> Merchant.get_merchant_account!(merchant_account.id) end
    end

    test "change_merchant_account/1 returns a merchant_account changeset" do
      merchant_account = merchant_account_fixture()
      assert %Ecto.Changeset{} = Merchant.change_merchant_account(merchant_account)
    end
  end
end
