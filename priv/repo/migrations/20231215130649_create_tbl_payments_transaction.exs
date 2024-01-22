defmodule Loanmanagementsystem.Repo.Migrations.CreateTblPaymentsTransaction do
  use Ecto.Migration

  def change do
    create table(:tbl_payments_transaction) do
      add :employee_id, :integer
      add :merchant_id, :integer
      add :loan_id, :integer
      add :employee_number, :string
      add :payment_amount, :float
      add :reference_no, :string

      timestamps()
    end

  end
end
