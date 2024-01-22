defmodule LoanSavingsSystem.RefundsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Refunds

  describe "tbl_refund_request" do
    alias LoanSavingsSystem.Refunds.Refund

    @valid_attrs %{amount: "some amount", company_id: "some company_id", customer_id: "some customer_id", loan_id: "some loan_id", status: "some status", transaction_id: "some transaction_id", user_id: "some user_id"}
    @update_attrs %{amount: "some updated amount", company_id: "some updated company_id", customer_id: "some updated customer_id", loan_id: "some updated loan_id", status: "some updated status", transaction_id: "some updated transaction_id", user_id: "some updated user_id"}
    @invalid_attrs %{amount: nil, company_id: nil, customer_id: nil, loan_id: nil, status: nil, transaction_id: nil, user_id: nil}

    def refund_fixture(attrs \\ %{}) do
      {:ok, refund} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Refunds.create_refund()

      refund
    end

    test "list_tbl_refund_request/0 returns all tbl_refund_request" do
      refund = refund_fixture()
      assert Refunds.list_tbl_refund_request() == [refund]
    end

    test "get_refund!/1 returns the refund with given id" do
      refund = refund_fixture()
      assert Refunds.get_refund!(refund.id) == refund
    end

    test "create_refund/1 with valid data creates a refund" do
      assert {:ok, %Refund{} = refund} = Refunds.create_refund(@valid_attrs)
      assert refund.amount == "some amount"
      assert refund.company_id == "some company_id"
      assert refund.customer_id == "some customer_id"
      assert refund.loan_id == "some loan_id"
      assert refund.status == "some status"
      assert refund.transaction_id == "some transaction_id"
      assert refund.user_id == "some user_id"
    end

    test "create_refund/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Refunds.create_refund(@invalid_attrs)
    end

    test "update_refund/2 with valid data updates the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{} = refund} = Refunds.update_refund(refund, @update_attrs)
      assert refund.amount == "some updated amount"
      assert refund.company_id == "some updated company_id"
      assert refund.customer_id == "some updated customer_id"
      assert refund.loan_id == "some updated loan_id"
      assert refund.status == "some updated status"
      assert refund.transaction_id == "some updated transaction_id"
      assert refund.user_id == "some updated user_id"
    end

    test "update_refund/2 with invalid data returns error changeset" do
      refund = refund_fixture()
      assert {:error, %Ecto.Changeset{}} = Refunds.update_refund(refund, @invalid_attrs)
      assert refund == Refunds.get_refund!(refund.id)
    end

    test "delete_refund/1 deletes the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{}} = Refunds.delete_refund(refund)
      assert_raise Ecto.NoResultsError, fn -> Refunds.get_refund!(refund.id) end
    end

    test "change_refund/1 returns a refund changeset" do
      refund = refund_fixture()
      assert %Ecto.Changeset{} = Refunds.change_refund(refund)
    end
  end

  describe "tbl_refund_request" do
    alias LoanSavingsSystem.Refunds.Refund

    @valid_attrs %{amount: "some amount", company_id: "some company_id", customer_id: "some customer_id", loan_id: "some loan_id", status: "some status", transaction_id: "some transaction_id", user_id: "some user_id"}
    @update_attrs %{amount: "some updated amount", company_id: "some updated company_id", customer_id: "some updated customer_id", loan_id: "some updated loan_id", status: "some updated status", transaction_id: "some updated transaction_id", user_id: "some updated user_id"}
    @invalid_attrs %{amount: nil, company_id: nil, customer_id: nil, loan_id: nil, status: nil, transaction_id: nil, user_id: nil}

    def refund_fixture(attrs \\ %{}) do
      {:ok, refund} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Refunds.create_refund()

      refund
    end

    test "list_tbl_refund_request/0 returns all tbl_refund_request" do
      refund = refund_fixture()
      assert Refunds.list_tbl_refund_request() == [refund]
    end

    test "get_refund!/1 returns the refund with given id" do
      refund = refund_fixture()
      assert Refunds.get_refund!(refund.id) == refund
    end

    test "create_refund/1 with valid data creates a refund" do
      assert {:ok, %Refund{} = refund} = Refunds.create_refund(@valid_attrs)
      assert refund.amount == "some amount"
      assert refund.company_id == "some company_id"
      assert refund.customer_id == "some customer_id"
      assert refund.loan_id == "some loan_id"
      assert refund.status == "some status"
      assert refund.transaction_id == "some transaction_id"
      assert refund.user_id == "some user_id"
    end

    test "create_refund/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Refunds.create_refund(@invalid_attrs)
    end

    test "update_refund/2 with valid data updates the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{} = refund} = Refunds.update_refund(refund, @update_attrs)
      assert refund.amount == "some updated amount"
      assert refund.company_id == "some updated company_id"
      assert refund.customer_id == "some updated customer_id"
      assert refund.loan_id == "some updated loan_id"
      assert refund.status == "some updated status"
      assert refund.transaction_id == "some updated transaction_id"
      assert refund.user_id == "some updated user_id"
    end

    test "update_refund/2 with invalid data returns error changeset" do
      refund = refund_fixture()
      assert {:error, %Ecto.Changeset{}} = Refunds.update_refund(refund, @invalid_attrs)
      assert refund == Refunds.get_refund!(refund.id)
    end

    test "delete_refund/1 deletes the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{}} = Refunds.delete_refund(refund)
      assert_raise Ecto.NoResultsError, fn -> Refunds.get_refund!(refund.id) end
    end

    test "change_refund/1 returns a refund changeset" do
      refund = refund_fixture()
      assert %Ecto.Changeset{} = Refunds.change_refund(refund)
    end
  end
end
