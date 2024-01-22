defmodule LoanSystem.Repo.Migrations.CreateTblLoanOfficerAssignment do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_officer_assignment) do
      add :loan_id, :integer
      add :loan_officer_id, :integer
      add :start_date, :date
      add :end_date, :date
      add :createdby_id, :integer
      add :created_date, :date
      add :updated_date, :date
      add :lastmodifiedby_id, :integer

      timestamps()
    end

  end
end
