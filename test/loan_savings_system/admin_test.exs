defmodule LoanSavingsSystem.AdminTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Admin

  describe "tbl_transactions" do
    alias LoanSavingsSystem.Admin.Transactions

    @valid_attrs %{amount: "some amount", external_id: "some external_id", phone_no: "some phone_no", refference_no: "some refference_no", tans_type: "some tans_type", tran_code: "some tran_code"}
    @update_attrs %{amount: "some updated amount", external_id: "some updated external_id", phone_no: "some updated phone_no", refference_no: "some updated refference_no", tans_type: "some updated tans_type", tran_code: "some updated tran_code"}
    @invalid_attrs %{amount: nil, external_id: nil, phone_no: nil, refference_no: nil, tans_type: nil, tran_code: nil}

    def transactions_fixture(attrs \\ %{}) do
      {:ok, transactions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_transactions()

      transactions
    end

    test "list_tbl_transactions/0 returns all tbl_transactions" do
      transactions = transactions_fixture()
      assert Admin.list_tbl_transactions() == [transactions]
    end

    test "get_transactions!/1 returns the transactions with given id" do
      transactions = transactions_fixture()
      assert Admin.get_transactions!(transactions.id) == transactions
    end

    test "create_transactions/1 with valid data creates a transactions" do
      assert {:ok, %Transactions{} = transactions} = Admin.create_transactions(@valid_attrs)
      assert transactions.amount == "some amount"
      assert transactions.external_id == "some external_id"
      assert transactions.phone_no == "some phone_no"
      assert transactions.refference_no == "some refference_no"
      assert transactions.tans_type == "some tans_type"
      assert transactions.tran_code == "some tran_code"
    end

    test "create_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_transactions(@invalid_attrs)
    end

    test "update_transactions/2 with valid data updates the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{} = transactions} = Admin.update_transactions(transactions, @update_attrs)
      assert transactions.amount == "some updated amount"
      assert transactions.external_id == "some updated external_id"
      assert transactions.phone_no == "some updated phone_no"
      assert transactions.refference_no == "some updated refference_no"
      assert transactions.tans_type == "some updated tans_type"
      assert transactions.tran_code == "some updated tran_code"
    end

    test "update_transactions/2 with invalid data returns error changeset" do
      transactions = transactions_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_transactions(transactions, @invalid_attrs)
      assert transactions == Admin.get_transactions!(transactions.id)
    end

    test "delete_transactions/1 deletes the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{}} = Admin.delete_transactions(transactions)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_transactions!(transactions.id) end
    end

    test "change_transactions/1 returns a transactions changeset" do
      transactions = transactions_fixture()
      assert %Ecto.Changeset{} = Admin.change_transactions(transactions)
    end
  end

  describe "tbl_divestments" do
    alias LoanSavingsSystem.Admin.Divestments

    @valid_attrs %{account_id: "some account_id", client_id: "some client_id", currency: "some currency", deposit_amount: "some deposit_amount", deposit_date: "some deposit_date", deposit_id: "some deposit_id", divest_amount: "some divest_amount", divest_date: "some divest_date", divest_rate_percentage: "some divest_rate_percentage", fixed_period_days: "some fixed_period_days", interest_accrued: "some interest_accrued", product_id: "some product_id"}
    @update_attrs %{account_id: "some updated account_id", client_id: "some updated client_id", currency: "some updated currency", deposit_amount: "some updated deposit_amount", deposit_date: "some updated deposit_date", deposit_id: "some updated deposit_id", divest_amount: "some updated divest_amount", divest_date: "some updated divest_date", divest_rate_percentage: "some updated divest_rate_percentage", fixed_period_days: "some updated fixed_period_days", interest_accrued: "some updated interest_accrued", product_id: "some updated product_id"}
    @invalid_attrs %{account_id: nil, client_id: nil, currency: nil, deposit_amount: nil, deposit_date: nil, deposit_id: nil, divest_amount: nil, divest_date: nil, divest_rate_percentage: nil, fixed_period_days: nil, interest_accrued: nil, product_id: nil}

    def divestments_fixture(attrs \\ %{}) do
      {:ok, divestments} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_divestments()

      divestments
    end

    test "list_tbl_divestments/0 returns all tbl_divestments" do
      divestments = divestments_fixture()
      assert Admin.list_tbl_divestments() == [divestments]
    end

    test "get_divestments!/1 returns the divestments with given id" do
      divestments = divestments_fixture()
      assert Admin.get_divestments!(divestments.id) == divestments
    end

    test "create_divestments/1 with valid data creates a divestments" do
      assert {:ok, %Divestments{} = divestments} = Admin.create_divestments(@valid_attrs)
      assert divestments.account_id == "some account_id"
      assert divestments.client_id == "some client_id"
      assert divestments.currency == "some currency"
      assert divestments.deposit_amount == "some deposit_amount"
      assert divestments.deposit_date == "some deposit_date"
      assert divestments.deposit_id == "some deposit_id"
      assert divestments.divest_amount == "some divest_amount"
      assert divestments.divest_date == "some divest_date"
      assert divestments.divest_rate_percentage == "some divest_rate_percentage"
      assert divestments.fixed_period_days == "some fixed_period_days"
      assert divestments.interest_accrued == "some interest_accrued"
      assert divestments.product_id == "some product_id"
    end

    test "create_divestments/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_divestments(@invalid_attrs)
    end

    test "update_divestments/2 with valid data updates the divestments" do
      divestments = divestments_fixture()
      assert {:ok, %Divestments{} = divestments} = Admin.update_divestments(divestments, @update_attrs)
      assert divestments.account_id == "some updated account_id"
      assert divestments.client_id == "some updated client_id"
      assert divestments.currency == "some updated currency"
      assert divestments.deposit_amount == "some updated deposit_amount"
      assert divestments.deposit_date == "some updated deposit_date"
      assert divestments.deposit_id == "some updated deposit_id"
      assert divestments.divest_amount == "some updated divest_amount"
      assert divestments.divest_date == "some updated divest_date"
      assert divestments.divest_rate_percentage == "some updated divest_rate_percentage"
      assert divestments.fixed_period_days == "some updated fixed_period_days"
      assert divestments.interest_accrued == "some updated interest_accrued"
      assert divestments.product_id == "some updated product_id"
    end

    test "update_divestments/2 with invalid data returns error changeset" do
      divestments = divestments_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_divestments(divestments, @invalid_attrs)
      assert divestments == Admin.get_divestments!(divestments.id)
    end

    test "delete_divestments/1 deletes the divestments" do
      divestments = divestments_fixture()
      assert {:ok, %Divestments{}} = Admin.delete_divestments(divestments)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_divestments!(divestments.id) end
    end

    test "change_divestments/1 returns a divestments changeset" do
      divestments = divestments_fixture()
      assert %Ecto.Changeset{} = Admin.change_divestments(divestments)
    end
  end
end
