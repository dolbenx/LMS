defmodule Loanmanagementsystem.Loan.Loan_invoice do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_invoice" do
    field :invoiceValue, :float
    field :paymentTerms, :string
    field :customer_id, :integer
    field :dateOfIssue, :date
    field :invoiceNo, :string
    field :loanID, :integer
    field :status, :string
    field :vendorName, :string

    timestamps()
  end

  @doc false
  def changeset(loan_invoice, attrs) do
    loan_invoice
    |> cast(attrs, [:customer_id, :invoiceValue, :loanID, :dateOfIssue, :paymentTerms, :status, :invoiceNo, :vendorName])
    # |> validate_required([:customer_id, :invoiceValue, :loanID, :dateOfIssue, :paymentTerms, :status, :invoiceNo, :vendorName])
  end
end
