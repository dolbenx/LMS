defmodule LoanSavingsSystem.TransactionsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Transactions

  describe "tbl_transactions" do
    alias LoanSavingsSystem.Transactions.Transaction

    @valid_attrs %{"": 42, accountId: 42, carriedOutByUserId: 42, carriedOutByUserRoleId: 42, isReversed: true, orderRef: "some orderRef", productId: 42, productType: "some productType", referenceNo: "some referenceNo", requestData: "some requestData", responseData: "some responseData", status: "some status", totalAmount: 120.5, transactionType: "some transactionType", userId: "some userId", userRoleId: "some userRoleId"}
    @update_attrs %{"": 43, accountId: 43, carriedOutByUserId: 43, carriedOutByUserRoleId: 43, isReversed: false, orderRef: "some updated orderRef", productId: 43, productType: "some updated productType", referenceNo: "some updated referenceNo", requestData: "some updated requestData", responseData: "some updated responseData", status: "some updated status", totalAmount: 456.7, transactionType: "some updated transactionType", userId: "some updated userId", userRoleId: "some updated userRoleId"}
    @invalid_attrs %{"": nil, accountId: nil, carriedOutByUserId: nil, carriedOutByUserRoleId: nil, isReversed: nil, orderRef: nil, productId: nil, productType: nil, referenceNo: nil, requestData: nil, responseData: nil, status: nil, totalAmount: nil, transactionType: nil, userId: nil, userRoleId: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    test "list_tbl_transactions/0 returns all tbl_transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_tbl_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs)
      assert transaction. == 42
      assert transaction.accountId == 42
      assert transaction.carriedOutByUserId == 42
      assert transaction.carriedOutByUserRoleId == 42
      assert transaction.isReversed == true
      assert transaction.orderRef == "some orderRef"
      assert transaction.productId == 42
      assert transaction.productType == "some productType"
      assert transaction.referenceNo == "some referenceNo"
      assert transaction.requestData == "some requestData"
      assert transaction.responseData == "some responseData"
      assert transaction.status == "some status"
      assert transaction.totalAmount == 120.5
      assert transaction.transactionType == "some transactionType"
      assert transaction.userId == "some userId"
      assert transaction.userRoleId == "some userRoleId"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, @update_attrs)
      assert transaction. == 43
      assert transaction.accountId == 43
      assert transaction.carriedOutByUserId == 43
      assert transaction.carriedOutByUserRoleId == 43
      assert transaction.isReversed == false
      assert transaction.orderRef == "some updated orderRef"
      assert transaction.productId == 43
      assert transaction.productType == "some updated productType"
      assert transaction.referenceNo == "some updated referenceNo"
      assert transaction.requestData == "some updated requestData"
      assert transaction.responseData == "some updated responseData"
      assert transaction.status == "some updated status"
      assert transaction.totalAmount == 456.7
      assert transaction.transactionType == "some updated transactionType"
      assert transaction.userId == "some updated userId"
      assert transaction.userRoleId == "some updated userRoleId"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
