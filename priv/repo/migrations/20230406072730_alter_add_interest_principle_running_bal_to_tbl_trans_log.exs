defmodule Loanmanagementsystem.Repo.Migrations.AlterAddInterestPrincipleRunningBalToTblTransLog do
  use Ecto.Migration

  def change do
    alter table(:tbl_trans_log) do
      add :interest, :float
      add :principle, :float
      add :running_balance, :float
    end
  end
end
