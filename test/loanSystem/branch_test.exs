defmodule LoanSystem.BranchTest do
  use LoanSystem.DataCase

  alias LoanSystem.Branch

  describe "tbl_branchs" do
    alias LoanSystem.Branch.Branchs

    @valid_attrs %{branch_address: "some branch_address", branch_district: "some branch_district", branch_name: "some branch_name", branch_province: "some branch_province", opening_date: ~D[2010-04-17], parent_branch_id: 42}
    @update_attrs %{branch_address: "some updated branch_address", branch_district: "some updated branch_district", branch_name: "some updated branch_name", branch_province: "some updated branch_province", opening_date: ~D[2011-05-18], parent_branch_id: 43}
    @invalid_attrs %{branch_address: nil, branch_district: nil, branch_name: nil, branch_province: nil, opening_date: nil, parent_branch_id: nil}

    def branchs_fixture(attrs \\ %{}) do
      {:ok, branchs} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Branch.create_branchs()

      branchs
    end

    test "list_tbl_branchs/0 returns all tbl_branchs" do
      branchs = branchs_fixture()
      assert Branch.list_tbl_branchs() == [branchs]
    end

    test "get_branchs!/1 returns the branchs with given id" do
      branchs = branchs_fixture()
      assert Branch.get_branchs!(branchs.id) == branchs
    end

    test "create_branchs/1 with valid data creates a branchs" do
      assert {:ok, %Branchs{} = branchs} = Branch.create_branchs(@valid_attrs)
      assert branchs.branch_address == "some branch_address"
      assert branchs.branch_district == "some branch_district"
      assert branchs.branch_name == "some branch_name"
      assert branchs.branch_province == "some branch_province"
      assert branchs.opening_date == ~D[2010-04-17]
      assert branchs.parent_branch_id == 42
    end

    test "create_branchs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Branch.create_branchs(@invalid_attrs)
    end

    test "update_branchs/2 with valid data updates the branchs" do
      branchs = branchs_fixture()
      assert {:ok, %Branchs{} = branchs} = Branch.update_branchs(branchs, @update_attrs)
      assert branchs.branch_address == "some updated branch_address"
      assert branchs.branch_district == "some updated branch_district"
      assert branchs.branch_name == "some updated branch_name"
      assert branchs.branch_province == "some updated branch_province"
      assert branchs.opening_date == ~D[2011-05-18]
      assert branchs.parent_branch_id == 43
    end

    test "update_branchs/2 with invalid data returns error changeset" do
      branchs = branchs_fixture()
      assert {:error, %Ecto.Changeset{}} = Branch.update_branchs(branchs, @invalid_attrs)
      assert branchs == Branch.get_branchs!(branchs.id)
    end

    test "delete_branchs/1 deletes the branchs" do
      branchs = branchs_fixture()
      assert {:ok, %Branchs{}} = Branch.delete_branchs(branchs)
      assert_raise Ecto.NoResultsError, fn -> Branch.get_branchs!(branchs.id) end
    end

    test "change_branchs/1 returns a branchs changeset" do
      branchs = branchs_fixture()
      assert %Ecto.Changeset{} = Branch.change_branchs(branchs)
    end
  end

  describe "tbl_branch_branch_transactions" do
    alias LoanSystem.Branch.BranchTransaction

    @valid_attrs %{currency_code: "some currency_code", details: "some details", receipient_branch_id: "some receipient_branch_id", source_branch_id: "some source_branch_id", transaction_amount: "some transaction_amount", transaction_date: "some transaction_date"}
    @update_attrs %{currency_code: "some updated currency_code", details: "some updated details", receipient_branch_id: "some updated receipient_branch_id", source_branch_id: "some updated source_branch_id", transaction_amount: "some updated transaction_amount", transaction_date: "some updated transaction_date"}
    @invalid_attrs %{currency_code: nil, details: nil, receipient_branch_id: nil, source_branch_id: nil, transaction_amount: nil, transaction_date: nil}

    def branch_transaction_fixture(attrs \\ %{}) do
      {:ok, branch_transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Branch.create_branch_transaction()

      branch_transaction
    end

    test "list_tbl_branch_branch_transactions/0 returns all tbl_branch_branch_transactions" do
      branch_transaction = branch_transaction_fixture()
      assert Branch.list_tbl_branch_branch_transactions() == [branch_transaction]
    end

    test "get_branch_transaction!/1 returns the branch_transaction with given id" do
      branch_transaction = branch_transaction_fixture()
      assert Branch.get_branch_transaction!(branch_transaction.id) == branch_transaction
    end

    test "create_branch_transaction/1 with valid data creates a branch_transaction" do
      assert {:ok, %BranchTransaction{} = branch_transaction} = Branch.create_branch_transaction(@valid_attrs)
      assert branch_transaction.currency_code == "some currency_code"
      assert branch_transaction.details == "some details"
      assert branch_transaction.receipient_branch_id == "some receipient_branch_id"
      assert branch_transaction.source_branch_id == "some source_branch_id"
      assert branch_transaction.transaction_amount == "some transaction_amount"
      assert branch_transaction.transaction_date == "some transaction_date"
    end

    test "create_branch_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Branch.create_branch_transaction(@invalid_attrs)
    end

    test "update_branch_transaction/2 with valid data updates the branch_transaction" do
      branch_transaction = branch_transaction_fixture()
      assert {:ok, %BranchTransaction{} = branch_transaction} = Branch.update_branch_transaction(branch_transaction, @update_attrs)
      assert branch_transaction.currency_code == "some updated currency_code"
      assert branch_transaction.details == "some updated details"
      assert branch_transaction.receipient_branch_id == "some updated receipient_branch_id"
      assert branch_transaction.source_branch_id == "some updated source_branch_id"
      assert branch_transaction.transaction_amount == "some updated transaction_amount"
      assert branch_transaction.transaction_date == "some updated transaction_date"
    end

    test "update_branch_transaction/2 with invalid data returns error changeset" do
      branch_transaction = branch_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Branch.update_branch_transaction(branch_transaction, @invalid_attrs)
      assert branch_transaction == Branch.get_branch_transaction!(branch_transaction.id)
    end

    test "delete_branch_transaction/1 deletes the branch_transaction" do
      branch_transaction = branch_transaction_fixture()
      assert {:ok, %BranchTransaction{}} = Branch.delete_branch_transaction(branch_transaction)
      assert_raise Ecto.NoResultsError, fn -> Branch.get_branch_transaction!(branch_transaction.id) end
    end

    test "change_branch_transaction/1 returns a branch_transaction changeset" do
      branch_transaction = branch_transaction_fixture()
      assert %Ecto.Changeset{} = Branch.change_branch_transaction(branch_transaction)
    end
  end
end
