defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanTblAddCroId do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :cro_id, :integer
    end
  end
end
