defmodule Loanmanagementsystem.Core_transaction.Batch_Processing do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  schema "tbl_batch_number" do
    field :batch_no, :string
    field :batch_type, :string, default: "DoubleEntries"
    field :status, :string, default: "0"
    field :trans_date, :string
    field :uuid, :string
    field :value_date, :string

    belongs_to :last_user, FundsMgt.Accounts.User, foreign_key: :last_user_id, type: :id
    belongs_to :current_user, FundsMgt.Accounts.User, foreign_key: :current_user_id, type: :id

    has_many :transactions, Loanmanagementsystem.Loan.LoanTransaction,
      foreign_key: :batch_id,
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(batch__processing, attrs) do
    batch__processing
    |> cast(attrs, [
      :batch_no,
      :status,
      :trans_date,
      :value_date,
      :batch_type,
      :uuid,
      :last_user_id,
      :current_user_id
    ])
    |> validate_required([:batch_no, :status, :trans_date, :value_date, :batch_type, :uuid])
  end
end
