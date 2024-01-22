defmodule Loanmanagementsystem.Core_transaction.Journal_entries do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_trans_log" do
    field :ac_gl, :string
    field :account_name, :string
    field :account_no, :string
    field :auth_status, :string
    field :batch_no, :string
    field :currency, :string
    field :drcr_ind, :string
    field :event, :string
    field :exch_rate, :string
    field :fcy_amount, :float
    field :financial_cycle, :string
    field :lcy_amount, :float
    field :mobile_no, :string
    field :module, :string
    field :period_code, :string
    field :process_status, :string
    field :product, :string
    field :trn_dt, :string
    field :trn_ref_no, :string
    field :user_id, :string
    field :value_dt, :string
    field :batch_status, :string
    field :narration, :string
    field :account_category, :string
    field :journalentry_filename, :string
    field :loan_id, :integer
    field :customer_id, :integer
    field :interest, :float
    field :principle, :float
    field :running_balance, :float
    field :closing_balance, :float

    belongs_to :batch, Loanmanagementsystem.Core_transaction.Batch_Processing,
      foreign_key: :batch_id,
      type: :id

    timestamps()
  end

  @doc false
  def changeset(journal_entries, attrs) do
    journal_entries
    |> cast(attrs, [
      :module,
      :trn_ref_no,
      :event,
      :interest,
      :principle,
      :running_balance,
      :closing_balance,
      # :account_category,
      :batch_status,
      :account_no,
      :account_name,
      :currency,
      :drcr_ind,
      :exch_rate,
      :fcy_amount,
      :lcy_amount,
      :trn_dt,
      :value_dt,
      :financial_cycle,
      :period_code,
      :user_id,
      :auth_status,
      :ac_gl,
      :mobile_no,
      :batch_no,
      :product,
      :process_status,
      :narration,
      :batch_id,
      :journalentry_filename,
      :loan_id,
      :customer_id,
    ])
    |> validate_required([
      :module,
      :event,
      :account_no,
      :account_name,
      :currency,
      :account_category,
      :drcr_ind,
      :fcy_amount,
      :lcy_amount,
      :trn_dt,
      :value_dt,
      :financial_cycle,
      :period_code,
      #:product,
      :process_status
    ])
  end
end
