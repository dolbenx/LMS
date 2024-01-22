defmodule Loanmanagementsystem.Repo.Migrations.ModifyLoansTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_loan_customer_details) do
      add :loan_id, :integer
    end
  end

  def down do
    alter table(:tbl_loan_customer_details) do
      remove :loan_id
    end
  end
end
