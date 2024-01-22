defmodule Loanmanagementsystem.Loan.Writtenoff_loans do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_writteoff_loans" do
    field :amount_writtenoff, :float
    field :client_name, :string
    field :customer_id, :integer
    field :date_of_writtenoff, :date
    field :loan_id, :integer
    field :reference_no, :string
    field :savings_account, :string
    field :writtenoff_by, :integer

    timestamps()
  end

  @doc false
  def changeset(writtenoff_loans, attrs) do
    writtenoff_loans
    |> cast(attrs, [:customer_id, :loan_id, :reference_no, :client_name, :date_of_writtenoff, :amount_writtenoff, :writtenoff_by, :savings_account])
    |> validate_required([:customer_id, :loan_id, :reference_no, :client_name, :date_of_writtenoff, :amount_writtenoff, :writtenoff_by])
  end
end
