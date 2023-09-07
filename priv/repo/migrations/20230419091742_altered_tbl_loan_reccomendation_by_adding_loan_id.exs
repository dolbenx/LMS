defmodule Loanmanagementsystem.Repo.Migrations.AlteredTblLoanReccomendationByAddingLoanId do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_recommendation) do
      add :loan_id, :integer

    end
  end
end
