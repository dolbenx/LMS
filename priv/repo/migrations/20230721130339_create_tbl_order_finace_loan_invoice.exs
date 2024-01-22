defmodule Loanmanagementsystem.Repo.Migrations.CreateTblOrderFinaceLoanInvoice do
  use Ecto.Migration

  def change do
    create table(:tbl_order_finace_loan_invoice) do
      add :item_description, :string
      add :order_value, :float
      add :order_number, :string
      add :tenor, :integer
      add :status, :string
      add :loan_id, :integer
      add :order_date, :date
      add :customer_id, :integer
      add :expected_due_date, :date

      timestamps()
    end

  end
end
