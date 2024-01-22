defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanDisbursementMethod do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_disbursement_method) do
      add :product_id, :integer
      add :currency, :string
      add :amount, :float
      add :disbursement_method, :string
      add :loan_id, :integer
      add :userId, :integer
      add :accountNumber, :string

      timestamps()
    end

  end
end
