defmodule Loanmanagementsystem.Repo.Migrations.ModifyEmployeeAccountTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_employee_account) do
      add :limit_balance, :float
    end
  end

  def down do
    alter table(:tbl_employee_account) do
      remove :limit_balance
    end
  end
end
