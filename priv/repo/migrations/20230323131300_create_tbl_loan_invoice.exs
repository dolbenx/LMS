defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanInvoice do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_invoice) do
      add :customer_id, :integer
      add :invoiceValue, :float
      add :loanID, :integer
      add :dateOfIssue, :date
      add :paymentTerms, :string
      add :status, :string
      add :invoiceNo, :string
      add :vendorName, :string

      timestamps()
    end

  end
end
