defmodule Loanmanagementsystem.Repo.Migrations.AlteredTblLoanAndAddedFieldDisbursementStatus do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :disbursement_status, :string


    end
  end
end
