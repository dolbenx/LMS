defmodule Loanmanagementsystem.Core_transaction do
  @moduledoc """
  The Core_transaction context.
  """

  # Loanmanagementsystem.Core_transaction.last_batch_usr("0008")
  # Loanmanagementsystem.Core_transaction.get_related_batch("0008", "56")
  # Loanmanagementsystem.Core_transaction.select_batch

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Core_transaction.Batch_Processing
  alias Loanmanagementsystem.Core_transaction.Journal_entries
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserBioData

  @doc """
  Returns the list of tbl_batch_number.

  ## Examples

      iex> list_tbl_batch_number()
      [%Batch_Processing{}, ...]

  """
  def list_tbl_batch_number do
    Repo.all(Batch_Processing)
  end


  def list_loan_accounts_details(customer_id) do
    UserBioData
    |> join(:left, [uB], la in "tbl_loans", on: la.customer_id == uB.userId)
    |> where([uB, la], la.loan_status == "DISBURSED" and la.customer_id == ^customer_id)
    |> select([uB, la], %{
      account_name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uB.firstName, uB.lastName, uB.otherName),
      account_no: uB.userId,
      type: "A"
    })
    |> group_by([uB, la], [uB.userId, uB.firstName, uB.lastName, uB.otherName])
    |> limit(1)
    |> Repo.one()
  end

  # ........................DATA ENTRY: Selecting batch with 0..................
  def data_entry_batch(user_id) do
    Repo.all(
      from(n in Batch_Processing,
        where: [status: "0", last_user_id: ^user_id, current_user_id: ^user_id]
      )
    )
  end

  def select_last_batch(user_id) do
    from(a in Batch_Processing,
      order_by: [desc: a.id],
      where: a.current_user_id == ^user_id and a.last_user_id == ^user_id,
      #  where: fragment("CAST(? as date) = CAST(GETDATE() as date)", a.trans_date),
      limit: 1,
      select: a
    )
    |> Repo.one()
  end

  def list_batch_items(batch_id) do
    Repo.all(
      from(n in Loanmanagementsystem.Core_transaction.Journal_entries,
        where: [batch_id: ^batch_id, batch_status: "ACTIVE"]
      )
    )
  end

  def list_batch_items_count(batch_id) do
    Repo.all(
      from(n in Loanmanagementsystem.Core_transaction.Journal_entries,
        where: [batch_id: ^batch_id, batch_status: "ACTIVE"]
      )
    )
    |> Enum.count()
  end

  def close_batch_items_auth(batch_id) do
    Journal_entries
    |> where(
      [a],
      a.batch_id == ^batch_id and
        a.batch_status == "PENDING_APPROVAL"
    )
    |> select([a], a)
    |> Repo.all()
  end

  def get_related_batch_auth(batch_id) do
    Repo.one(
      from(n in Batch_Processing,
        where: [id: ^batch_id]
      )
    )
  end

  def close_batch_items(batch_no, batch_id) do
    Repo.all(
      from(n in Journal_entries,
        where: [batch_no: ^batch_no, batch_id: ^batch_id, batch_status: "ACTIVE"]
      )
    )
  end

  def get_related_batch(batch_no, batch_id) do
    Repo.one(
      from(n in Batch_Processing,
        where: [batch_no: ^batch_no, id: ^batch_id]
      )
    )
  end

  def close_batch_items_discard(batch_id) do
    Repo.all(
      from(n in Journal_entries,
        where: [batch_id: ^batch_id, batch_status: "PENDING_APPROVAL"]
      )
    )
  end

  def get_related_batch_discard(batch_id) do
    Repo.one(
      from(n in Batch_Processing,
        where: [id: ^batch_id]
      )
    )
  end

  def recall_batch(user_id) do
    Repo.all(
      from(n in Batch_Processing,
        where: [status: "1", last_user_id: ^user_id, current_user_id: ^user_id]
      )
    )
  end

  def active_batch_params do
    Repo.all(from(n in Batch_Processing, where: [status: "1"]))
  end

  # def last_batch_usr(batch_id) do
  #   Batch_Processing
  #   |> where([a], a.id == ^batch_id)
  #   |> preload([_a], [:last_user])
  #   |> select(
  #     [a],
  #     map(a, [:id, :batch_no, :last_user_id, last_user: [:id, :username]])
  #   )
  #   |> Repo.one()
  # end

  def last_batch_usr(batch_id) do
    Batch_Processing
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.last_user_id == uB.userId)
    |> select([uA, uB], %{
      id: uA.id,
      last_user_id: uA.last_user_id,
      firstName: uB.firstName,
      lastName: uB.lastName
    })
    |> limit(1)
    |> Repo.one()
  end

  def list_batch_items_to_approve(batch_id) do
    Journal_entries
    |> where([a], a.batch_status == "PENDING_APPROVAL" and a.batch_id == ^batch_id)
    |> select([a], a)
    |> Repo.all()
  end

  def select_batch do
    Batch_Processing
    |> where([a], a.batch_type in ["DoubleEntries"])
    |> where(
      [a],
      fragment(
        "(select count(*) from tbl_trans_log where batch_status = 'PENDING_APPROVAL' and batch_id = ? and process_status = 'PENDING_APPROVAL')",
        a.id
      ) >= 1
    )
    |> Repo.all()
  end

  # Balance Sheet
  def get_balancesheet_aggreated_balances do
    Journal_entries
    |> where(
      [a],
      a.process_status == "APPROVED" and
        a.batch_status == "APPROVED"
    )
    |> select(
      [a],
      %{
        total_dr:
          fragment(
            "select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED' and account_category != 'Income' and account_category != 'Expenses' ",
            "D"
          ),
        total_cr:
          fragment(
            "select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED' and account_category != 'Income' and account_category != 'Expenses' ",
            "C"
          )
      }
    )
    |> distinct(true)
    |> Repo.all()
  end

  # Income Statement
  def get_incomestatement_aggreated_balances do
    Journal_entries
    |> where(
      [a],
      a.process_status == "APPROVED" and
        a.batch_status == "APPROVED"
    )
    |> select(
      [a],
      %{
        total_dr:
          fragment(
            "select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED' and account_category != 'Assets' and account_category != 'Liabilities' ",
            "D"
          ),
        total_cr:
          fragment(
            "select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED' and account_category != 'Assets' and account_category != 'Liabilities' ",
            "C"
          )
      }
    )
    |> distinct(true)
    |> Repo.all()
  end

  # Trial balance
  def get_trialbalance_aggreated_balances do
    Journal_entries
    |> where(
      [a],
      a.process_status == "APPROVED" and
        a.batch_status == "APPROVED"
    )
    |> select(
      [a],
      %{
        total_dr:
          fragment(
            "select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED'  ",
            "D"
          ),
        total_cr:
          fragment(
            "select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED'  ",
            "C"
          )
      }
    )
    |> distinct(true)
    |> Repo.all()
  end

  # Genaral Ledger
  # def get_generalledger_aggreated_balances do
  #   Journal_entries
  #   |> where([a], a.process_status == "APPROVED"
  #     and a.batch_status == "APPROVED"
  #   )
  #   |> select([a],
  #   %{
  #     total_dr:  fragment("select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED'  ", "D"),
  #     total_cr:   fragment("select sum(lcy_amount + fcy_amount) from tbl_trans_log where drcr_ind =  ? and process_status = 'APPROVED'  and batch_status = 'APPROVED'  ", "C")
  #   })
  #   |> distinct(true)
  #   |> Repo.all()
  # end

  @doc """
  Gets a single batch__processing.

  Raises `Ecto.NoResultsError` if the Batch  processing does not exist.

  ## Examples

      iex> get_batch__processing!(123)
      %Batch_Processing{}

      iex> get_batch__processing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_batch__processing!(id), do: Repo.get!(Batch_Processing, id)

  @doc """
  Creates a batch__processing.

  ## Examples

      iex> create_batch__processing(%{field: value})
      {:ok, %Batch_Processing{}}

      iex> create_batch__processing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_batch__processing(attrs \\ %{}) do
    %Batch_Processing{}
    |> Batch_Processing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a batch__processing.

  ## Examples

      iex> update_batch__processing(batch__processing, %{field: new_value})
      {:ok, %Batch_Processing{}}

      iex> update_batch__processing(batch__processing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_batch__processing(%Batch_Processing{} = batch__processing, attrs) do
    batch__processing
    |> Batch_Processing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a batch__processing.

  ## Examples

      iex> delete_batch__processing(batch__processing)
      {:ok, %Batch_Processing{}}

      iex> delete_batch__processing(batch__processing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_batch__processing(%Batch_Processing{} = batch__processing) do
    Repo.delete(batch__processing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking batch__processing changes.

  ## Examples

      iex> change_batch__processing(batch__processing)
      %Ecto.Changeset{data: %Batch_Processing{}}

  """
  def change_batch__processing(%Batch_Processing{} = batch__processing, attrs \\ %{}) do
    Batch_Processing.changeset(batch__processing, attrs)
  end

  @doc """
  Returns the list of tbl_trans_log.

  ## Examples

      iex> list_tbl_trans_log()
      [%Journal_entries{}, ...]

  """
  def list_tbl_trans_log do
    Repo.all(Journal_entries)
  end

  @doc """
  Gets a single journal_entries.

  Raises `Ecto.NoResultsError` if the Journal entries does not exist.

  ## Examples

      iex> get_journal_entries!(123)
      %Journal_entries{}

      iex> get_journal_entries!(456)
      ** (Ecto.NoResultsError)

  """
  def get_journal_entries!(id), do: Repo.get!(Journal_entries, id)

  @doc """
  Creates a journal_entries.

  ## Examples

      iex> create_journal_entries(%{field: value})
      {:ok, %Journal_entries{}}

      iex> create_journal_entries(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_journal_entries(attrs \\ %{}) do
    %Journal_entries{}
    |> Journal_entries.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a journal_entries.

  ## Examples

      iex> update_journal_entries(journal_entries, %{field: new_value})
      {:ok, %Journal_entries{}}

      iex> update_journal_entries(journal_entries, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_journal_entries(%Journal_entries{} = journal_entries, attrs) do
    journal_entries
    |> Journal_entries.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a journal_entries.

  ## Examples

      iex> delete_journal_entries(journal_entries)
      {:ok, %Journal_entries{}}

      iex> delete_journal_entries(journal_entries)
      {:error, %Ecto.Changeset{}}

  """
  def delete_journal_entries(%Journal_entries{} = journal_entries) do
    Repo.delete(journal_entries)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking journal_entries changes.

  ## Examples

      iex> change_journal_entries(journal_entries)
      %Ecto.Changeset{data: %Journal_entries{}}

  """
  def change_journal_entries(%Journal_entries{} = journal_entries, attrs \\ %{}) do
    Journal_entries.changeset(journal_entries, attrs)
  end


  def list_customer_repayments(user_id) do
    Journal_entries
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], lO in "tbl_loans", on: lO.customer_id == uB.userId)
    |> join(:left, [l, s, uB, lO], p in "tbl_products", on: lO.product_id == p.id)
    |> where([l, s, uB, lO, p], l.customer_id == ^user_id and l.process_status == "APPROVED")
    |> select(
      [l, s, uB, lO, p],
      %{
        customer: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
        product_name: p.name,
        phone: uB.mobileNumber,
        amount: fragment("select ROUND(CAST( lcy_amount  AS numeric), 2) from  tbl_trans_log where id = ?", l.id),
        date: l.trn_dt,
        narration: l.narration

      }
    )
    |> order_by([l, s, uB, lO, p], desc: l.inserted_at)
    |> Repo.all
  end


  def consolidated_account_details_to_update do
    query = """
      SELECT account_no, currency, sum(case when drcr_ind='C' then  fcy_amount else  -fcy_amount end) as fcy_amount, sum(case when drcr_ind='C' then  lcy_amount else  -lcy_amount end) as lcy_amount
      FROM tbl_trans_log
      WHERE auth_status='A' AND process_status = 'APPROVED'
      GROUP BY  account_no, currency

    """

    {:ok, %{columns: columns, rows: rows}} = Repo.query(query, [])
    columns = Enum.map(columns, &String.to_atom(&1))

    rows
    |> Enum.map(&Enum.zip(columns, &1))
    |> Enum.map(&Enum.into(&1, %{}))
  end
end
