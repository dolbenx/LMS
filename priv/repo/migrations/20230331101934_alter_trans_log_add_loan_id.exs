defmodule Loanmanagementsystem.Repo.Migrations.AlterTransLogAddLoanId do
  use Ecto.Migration

  def change do
    alter table(:tbl_trans_log) do
      add :loan_id, :integer
      add :customer_id, :integer
    end
  end
end
