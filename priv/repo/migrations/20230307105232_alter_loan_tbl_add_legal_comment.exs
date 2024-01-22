defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanTblAddLegalComment do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :legal_collateral_comment, :text
      add :credit_mgt_committe_comment, :text

    end
  end
end
