defmodule LoanSavingsSystem.MainetenceTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Mainetence

  describe "tbl_gl_closure" do
    alias LoanSavingsSystem.Mainetence.Gl_Closure

    @valid_attrs %{client_id: "some client_id", closed_by_user_id: "some closed_by_user_id", comments: "some comments", date_closed: "some date_closed"}
    @update_attrs %{client_id: "some updated client_id", closed_by_user_id: "some updated closed_by_user_id", comments: "some updated comments", date_closed: "some updated date_closed"}
    @invalid_attrs %{client_id: nil, closed_by_user_id: nil, comments: nil, date_closed: nil}

    def gl__closure_fixture(attrs \\ %{}) do
      {:ok, gl__closure} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mainetence.create_gl__closure()

      gl__closure
    end

    test "list_tbl_gl_closure/0 returns all tbl_gl_closure" do
      gl__closure = gl__closure_fixture()
      assert Mainetence.list_tbl_gl_closure() == [gl__closure]
    end

    test "get_gl__closure!/1 returns the gl__closure with given id" do
      gl__closure = gl__closure_fixture()
      assert Mainetence.get_gl__closure!(gl__closure.id) == gl__closure
    end

    test "create_gl__closure/1 with valid data creates a gl__closure" do
      assert {:ok, %Gl_Closure{} = gl__closure} = Mainetence.create_gl__closure(@valid_attrs)
      assert gl__closure.client_id == "some client_id"
      assert gl__closure.closed_by_user_id == "some closed_by_user_id"
      assert gl__closure.comments == "some comments"
      assert gl__closure.date_closed == "some date_closed"
    end

    test "create_gl__closure/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mainetence.create_gl__closure(@invalid_attrs)
    end

    test "update_gl__closure/2 with valid data updates the gl__closure" do
      gl__closure = gl__closure_fixture()
      assert {:ok, %Gl_Closure{} = gl__closure} = Mainetence.update_gl__closure(gl__closure, @update_attrs)
      assert gl__closure.client_id == "some updated client_id"
      assert gl__closure.closed_by_user_id == "some updated closed_by_user_id"
      assert gl__closure.comments == "some updated comments"
      assert gl__closure.date_closed == "some updated date_closed"
    end

    test "update_gl__closure/2 with invalid data returns error changeset" do
      gl__closure = gl__closure_fixture()
      assert {:error, %Ecto.Changeset{}} = Mainetence.update_gl__closure(gl__closure, @invalid_attrs)
      assert gl__closure == Mainetence.get_gl__closure!(gl__closure.id)
    end

    test "delete_gl__closure/1 deletes the gl__closure" do
      gl__closure = gl__closure_fixture()
      assert {:ok, %Gl_Closure{}} = Mainetence.delete_gl__closure(gl__closure)
      assert_raise Ecto.NoResultsError, fn -> Mainetence.get_gl__closure!(gl__closure.id) end
    end

    test "change_gl__closure/1 returns a gl__closure changeset" do
      gl__closure = gl__closure_fixture()
      assert %Ecto.Changeset{} = Mainetence.change_gl__closure(gl__closure)
    end
  end

  describe "tbl_charge" do
    alias LoanSavingsSystem.Mainetence.Charge

    @valid_attrs %{amount: "some amount", applicable_to_product_type: "some applicable_to_product_type", charge_name: "some charge_name", charge_time_type: "some charge_time_type", client_id: "some client_id", currency: "some currency", is_penalty: "some is_penalty", status: "some status"}
    @update_attrs %{amount: "some updated amount", applicable_to_product_type: "some updated applicable_to_product_type", charge_name: "some updated charge_name", charge_time_type: "some updated charge_time_type", client_id: "some updated client_id", currency: "some updated currency", is_penalty: "some updated is_penalty", status: "some updated status"}
    @invalid_attrs %{amount: nil, applicable_to_product_type: nil, charge_name: nil, charge_time_type: nil, client_id: nil, currency: nil, is_penalty: nil, status: nil}

    def charge_fixture(attrs \\ %{}) do
      {:ok, charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mainetence.create_charge()

      charge
    end

    test "list_tbl_charge/0 returns all tbl_charge" do
      charge = charge_fixture()
      assert Mainetence.list_tbl_charge() == [charge]
    end

    test "get_charge!/1 returns the charge with given id" do
      charge = charge_fixture()
      assert Mainetence.get_charge!(charge.id) == charge
    end

    test "create_charge/1 with valid data creates a charge" do
      assert {:ok, %Charge{} = charge} = Mainetence.create_charge(@valid_attrs)
      assert charge.amount == "some amount"
      assert charge.applicable_to_product_type == "some applicable_to_product_type"
      assert charge.charge_name == "some charge_name"
      assert charge.charge_time_type == "some charge_time_type"
      assert charge.client_id == "some client_id"
      assert charge.currency == "some currency"
      assert charge.is_penalty == "some is_penalty"
      assert charge.status == "some status"
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mainetence.create_charge(@invalid_attrs)
    end

    test "update_charge/2 with valid data updates the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{} = charge} = Mainetence.update_charge(charge, @update_attrs)
      assert charge.amount == "some updated amount"
      assert charge.applicable_to_product_type == "some updated applicable_to_product_type"
      assert charge.charge_name == "some updated charge_name"
      assert charge.charge_time_type == "some updated charge_time_type"
      assert charge.client_id == "some updated client_id"
      assert charge.currency == "some updated currency"
      assert charge.is_penalty == "some updated is_penalty"
      assert charge.status == "some updated status"
    end

    test "update_charge/2 with invalid data returns error changeset" do
      charge = charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Mainetence.update_charge(charge, @invalid_attrs)
      assert charge == Mainetence.get_charge!(charge.id)
    end

    test "delete_charge/1 deletes the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{}} = Mainetence.delete_charge(charge)
      assert_raise Ecto.NoResultsError, fn -> Mainetence.get_charge!(charge.id) end
    end

    test "change_charge/1 returns a charge changeset" do
      charge = charge_fixture()
      assert %Ecto.Changeset{} = Mainetence.change_charge(charge)
    end
  end

  describe "tbl_journal_entry" do
    alias LoanSavingsSystem.Mainetence.Journal_Entry

    @valid_attrs %{account_id: "some account_id", amount: "some amount", client_id: "some client_id", created_by_user_id: "some created_by_user_id", currency: "some currency", details: "some details", entry_date: "some entry_date", is_manual_entry: "some is_manual_entry", is_reversed: "some is_reversed", is_system_entry: "some is_system_entry", journal_entry_type: "some journal_entry_type", product_type_id: "some product_type_id", reversal_id: "some reversal_id", transaction_id: "some transaction_id"}
    @update_attrs %{account_id: "some updated account_id", amount: "some updated amount", client_id: "some updated client_id", created_by_user_id: "some updated created_by_user_id", currency: "some updated currency", details: "some updated details", entry_date: "some updated entry_date", is_manual_entry: "some updated is_manual_entry", is_reversed: "some updated is_reversed", is_system_entry: "some updated is_system_entry", journal_entry_type: "some updated journal_entry_type", product_type_id: "some updated product_type_id", reversal_id: "some updated reversal_id", transaction_id: "some updated transaction_id"}
    @invalid_attrs %{account_id: nil, amount: nil, client_id: nil, created_by_user_id: nil, currency: nil, details: nil, entry_date: nil, is_manual_entry: nil, is_reversed: nil, is_system_entry: nil, journal_entry_type: nil, product_type_id: nil, reversal_id: nil, transaction_id: nil}

    def journal__entry_fixture(attrs \\ %{}) do
      {:ok, journal__entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mainetence.create_journal__entry()

      journal__entry
    end

    test "list_tbl_journal_entry/0 returns all tbl_journal_entry" do
      journal__entry = journal__entry_fixture()
      assert Mainetence.list_tbl_journal_entry() == [journal__entry]
    end

    test "get_journal__entry!/1 returns the journal__entry with given id" do
      journal__entry = journal__entry_fixture()
      assert Mainetence.get_journal__entry!(journal__entry.id) == journal__entry
    end

    test "create_journal__entry/1 with valid data creates a journal__entry" do
      assert {:ok, %Journal_Entry{} = journal__entry} = Mainetence.create_journal__entry(@valid_attrs)
      assert journal__entry.account_id == "some account_id"
      assert journal__entry.amount == "some amount"
      assert journal__entry.client_id == "some client_id"
      assert journal__entry.created_by_user_id == "some created_by_user_id"
      assert journal__entry.currency == "some currency"
      assert journal__entry.details == "some details"
      assert journal__entry.entry_date == "some entry_date"
      assert journal__entry.is_manual_entry == "some is_manual_entry"
      assert journal__entry.is_reversed == "some is_reversed"
      assert journal__entry.is_system_entry == "some is_system_entry"
      assert journal__entry.journal_entry_type == "some journal_entry_type"
      assert journal__entry.product_type_id == "some product_type_id"
      assert journal__entry.reversal_id == "some reversal_id"
      assert journal__entry.transaction_id == "some transaction_id"
    end

    test "create_journal__entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mainetence.create_journal__entry(@invalid_attrs)
    end

    test "update_journal__entry/2 with valid data updates the journal__entry" do
      journal__entry = journal__entry_fixture()
      assert {:ok, %Journal_Entry{} = journal__entry} = Mainetence.update_journal__entry(journal__entry, @update_attrs)
      assert journal__entry.account_id == "some updated account_id"
      assert journal__entry.amount == "some updated amount"
      assert journal__entry.client_id == "some updated client_id"
      assert journal__entry.created_by_user_id == "some updated created_by_user_id"
      assert journal__entry.currency == "some updated currency"
      assert journal__entry.details == "some updated details"
      assert journal__entry.entry_date == "some updated entry_date"
      assert journal__entry.is_manual_entry == "some updated is_manual_entry"
      assert journal__entry.is_reversed == "some updated is_reversed"
      assert journal__entry.is_system_entry == "some updated is_system_entry"
      assert journal__entry.journal_entry_type == "some updated journal_entry_type"
      assert journal__entry.product_type_id == "some updated product_type_id"
      assert journal__entry.reversal_id == "some updated reversal_id"
      assert journal__entry.transaction_id == "some updated transaction_id"
    end

    test "update_journal__entry/2 with invalid data returns error changeset" do
      journal__entry = journal__entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Mainetence.update_journal__entry(journal__entry, @invalid_attrs)
      assert journal__entry == Mainetence.get_journal__entry!(journal__entry.id)
    end

    test "delete_journal__entry/1 deletes the journal__entry" do
      journal__entry = journal__entry_fixture()
      assert {:ok, %Journal_Entry{}} = Mainetence.delete_journal__entry(journal__entry)
      assert_raise Ecto.NoResultsError, fn -> Mainetence.get_journal__entry!(journal__entry.id) end
    end

    test "change_journal__entry/1 returns a journal__entry changeset" do
      journal__entry = journal__entry_fixture()
      assert %Ecto.Changeset{} = Mainetence.change_journal__entry(journal__entry)
    end
  end
end
