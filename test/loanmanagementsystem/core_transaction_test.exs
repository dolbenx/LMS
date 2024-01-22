defmodule Loanmanagementsystem.Core_transactionTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Core_transaction

  describe "tbl_batch_number" do
    alias Loanmanagementsystem.Core_transaction.Batch_Processing

    @valid_attrs %{
      batch_no: "some batch_no",
      batch_type: "some batch_type",
      status: "some status",
      trans_date: "some trans_date",
      uuid: "some uuid",
      value_date: "some value_date"
    }
    @update_attrs %{
      batch_no: "some updated batch_no",
      batch_type: "some updated batch_type",
      status: "some updated status",
      trans_date: "some updated trans_date",
      uuid: "some updated uuid",
      value_date: "some updated value_date"
    }
    @invalid_attrs %{
      batch_no: nil,
      batch_type: nil,
      status: nil,
      trans_date: nil,
      uuid: nil,
      value_date: nil
    }

    def batch__processing_fixture(attrs \\ %{}) do
      {:ok, batch__processing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core_transaction.create_batch__processing()

      batch__processing
    end

    test "list_tbl_batch_number/0 returns all tbl_batch_number" do
      batch__processing = batch__processing_fixture()
      assert Core_transaction.list_tbl_batch_number() == [batch__processing]
    end

    test "get_batch__processing!/1 returns the batch__processing with given id" do
      batch__processing = batch__processing_fixture()
      assert Core_transaction.get_batch__processing!(batch__processing.id) == batch__processing
    end

    test "create_batch__processing/1 with valid data creates a batch__processing" do
      assert {:ok, %Batch_Processing{} = batch__processing} =
               Core_transaction.create_batch__processing(@valid_attrs)

      assert batch__processing.batch_no == "some batch_no"
      assert batch__processing.batch_type == "some batch_type"
      assert batch__processing.status == "some status"
      assert batch__processing.trans_date == "some trans_date"
      assert batch__processing.uuid == "some uuid"
      assert batch__processing.value_date == "some value_date"
    end

    test "create_batch__processing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Core_transaction.create_batch__processing(@invalid_attrs)
    end

    test "update_batch__processing/2 with valid data updates the batch__processing" do
      batch__processing = batch__processing_fixture()

      assert {:ok, %Batch_Processing{} = batch__processing} =
               Core_transaction.update_batch__processing(batch__processing, @update_attrs)

      assert batch__processing.batch_no == "some updated batch_no"
      assert batch__processing.batch_type == "some updated batch_type"
      assert batch__processing.status == "some updated status"
      assert batch__processing.trans_date == "some updated trans_date"
      assert batch__processing.uuid == "some updated uuid"
      assert batch__processing.value_date == "some updated value_date"
    end

    test "update_batch__processing/2 with invalid data returns error changeset" do
      batch__processing = batch__processing_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Core_transaction.update_batch__processing(batch__processing, @invalid_attrs)

      assert batch__processing == Core_transaction.get_batch__processing!(batch__processing.id)
    end

    test "delete_batch__processing/1 deletes the batch__processing" do
      batch__processing = batch__processing_fixture()

      assert {:ok, %Batch_Processing{}} =
               Core_transaction.delete_batch__processing(batch__processing)

      assert_raise Ecto.NoResultsError, fn ->
        Core_transaction.get_batch__processing!(batch__processing.id)
      end
    end

    test "change_batch__processing/1 returns a batch__processing changeset" do
      batch__processing = batch__processing_fixture()
      assert %Ecto.Changeset{} = Core_transaction.change_batch__processing(batch__processing)
    end
  end

  describe "tbl_trans_log" do
    alias Loanmanagementsystem.Core_transaction.Journal_entries

    @valid_attrs %{
      ac_gl: "some ac_gl",
      account_name: "some account_name",
      account_no: "some account_no",
      auth_status: "some auth_status",
      batch_no: "some batch_no",
      currency: "some currency",
      drcr_ind: "some drcr_ind",
      event: "some event",
      exch_rate: "some exch_rate",
      fcy_amount: 120.5,
      financial_cycle: "some financial_cycle",
      lcy_amount: 120.5,
      mobile_no: "some mobile_no",
      module: "some module",
      period_code: "some period_code",
      process_status: "some process_status",
      product: "some product",
      trn_dt: "some trn_dt",
      trn_ref_no: "some trn_ref_no",
      user_id: "some user_id",
      value_dt: "some value_dt"
    }
    @update_attrs %{
      ac_gl: "some updated ac_gl",
      account_name: "some updated account_name",
      account_no: "some updated account_no",
      auth_status: "some updated auth_status",
      batch_no: "some updated batch_no",
      currency: "some updated currency",
      drcr_ind: "some updated drcr_ind",
      event: "some updated event",
      exch_rate: "some updated exch_rate",
      fcy_amount: 456.7,
      financial_cycle: "some updated financial_cycle",
      lcy_amount: 456.7,
      mobile_no: "some updated mobile_no",
      module: "some updated module",
      period_code: "some updated period_code",
      process_status: "some updated process_status",
      product: "some updated product",
      trn_dt: "some updated trn_dt",
      trn_ref_no: "some updated trn_ref_no",
      user_id: "some updated user_id",
      value_dt: "some updated value_dt"
    }
    @invalid_attrs %{
      ac_gl: nil,
      account_name: nil,
      account_no: nil,
      auth_status: nil,
      batch_no: nil,
      currency: nil,
      drcr_ind: nil,
      event: nil,
      exch_rate: nil,
      fcy_amount: nil,
      financial_cycle: nil,
      lcy_amount: nil,
      mobile_no: nil,
      module: nil,
      period_code: nil,
      process_status: nil,
      product: nil,
      trn_dt: nil,
      trn_ref_no: nil,
      user_id: nil,
      value_dt: nil
    }

    def journal_entries_fixture(attrs \\ %{}) do
      {:ok, journal_entries} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core_transaction.create_journal_entries()

      journal_entries
    end

    test "list_tbl_trans_log/0 returns all tbl_trans_log" do
      journal_entries = journal_entries_fixture()
      assert Core_transaction.list_tbl_trans_log() == [journal_entries]
    end

    test "get_journal_entries!/1 returns the journal_entries with given id" do
      journal_entries = journal_entries_fixture()
      assert Core_transaction.get_journal_entries!(journal_entries.id) == journal_entries
    end

    test "create_journal_entries/1 with valid data creates a journal_entries" do
      assert {:ok, %Journal_entries{} = journal_entries} =
               Core_transaction.create_journal_entries(@valid_attrs)

      assert journal_entries.ac_gl == "some ac_gl"
      assert journal_entries.account_name == "some account_name"
      assert journal_entries.account_no == "some account_no"
      assert journal_entries.auth_status == "some auth_status"
      assert journal_entries.batch_no == "some batch_no"
      assert journal_entries.currency == "some currency"
      assert journal_entries.drcr_ind == "some drcr_ind"
      assert journal_entries.event == "some event"
      assert journal_entries.exch_rate == "some exch_rate"
      assert journal_entries.fcy_amount == 120.5
      assert journal_entries.financial_cycle == "some financial_cycle"
      assert journal_entries.lcy_amount == 120.5
      assert journal_entries.mobile_no == "some mobile_no"
      assert journal_entries.module == "some module"
      assert journal_entries.period_code == "some period_code"
      assert journal_entries.process_status == "some process_status"
      assert journal_entries.product == "some product"
      assert journal_entries.trn_dt == "some trn_dt"
      assert journal_entries.trn_ref_no == "some trn_ref_no"
      assert journal_entries.user_id == "some user_id"
      assert journal_entries.value_dt == "some value_dt"
    end

    test "create_journal_entries/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core_transaction.create_journal_entries(@invalid_attrs)
    end

    test "update_journal_entries/2 with valid data updates the journal_entries" do
      journal_entries = journal_entries_fixture()

      assert {:ok, %Journal_entries{} = journal_entries} =
               Core_transaction.update_journal_entries(journal_entries, @update_attrs)

      assert journal_entries.ac_gl == "some updated ac_gl"
      assert journal_entries.account_name == "some updated account_name"
      assert journal_entries.account_no == "some updated account_no"
      assert journal_entries.auth_status == "some updated auth_status"
      assert journal_entries.batch_no == "some updated batch_no"
      assert journal_entries.currency == "some updated currency"
      assert journal_entries.drcr_ind == "some updated drcr_ind"
      assert journal_entries.event == "some updated event"
      assert journal_entries.exch_rate == "some updated exch_rate"
      assert journal_entries.fcy_amount == 456.7
      assert journal_entries.financial_cycle == "some updated financial_cycle"
      assert journal_entries.lcy_amount == 456.7
      assert journal_entries.mobile_no == "some updated mobile_no"
      assert journal_entries.module == "some updated module"
      assert journal_entries.period_code == "some updated period_code"
      assert journal_entries.process_status == "some updated process_status"
      assert journal_entries.product == "some updated product"
      assert journal_entries.trn_dt == "some updated trn_dt"
      assert journal_entries.trn_ref_no == "some updated trn_ref_no"
      assert journal_entries.user_id == "some updated user_id"
      assert journal_entries.value_dt == "some updated value_dt"
    end

    test "update_journal_entries/2 with invalid data returns error changeset" do
      journal_entries = journal_entries_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Core_transaction.update_journal_entries(journal_entries, @invalid_attrs)

      assert journal_entries == Core_transaction.get_journal_entries!(journal_entries.id)
    end

    test "delete_journal_entries/1 deletes the journal_entries" do
      journal_entries = journal_entries_fixture()
      assert {:ok, %Journal_entries{}} = Core_transaction.delete_journal_entries(journal_entries)

      assert_raise Ecto.NoResultsError, fn ->
        Core_transaction.get_journal_entries!(journal_entries.id)
      end
    end

    test "change_journal_entries/1 returns a journal_entries changeset" do
      journal_entries = journal_entries_fixture()
      assert %Ecto.Changeset{} = Core_transaction.change_journal_entries(journal_entries)
    end
  end
end
