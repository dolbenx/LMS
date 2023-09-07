defmodule Loanmanagementsystem.Repo.Migrations.AddingFieldsInTblCustomerAccounts do
  use Ecto.Migration


  def up do
    alter table(:tbl_customer_accounts) do
      add :previous_Rm, :integer
      add :assignment_date, :date
    end
  end

  def down do
    alter table(:tbl_customer_accounts) do
      remove :previous_Rm
      remove :assignment_date
    end
  end
end
