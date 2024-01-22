defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoan5csAnalysis do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_5cs_analysis) do
      add :customer_id, :integer
      add :loan_id, :integer
      add :reference_no, :string
      add :character, :text
      add :capacity, :text
      add :capital, :text
      add :condition, :text
      add :collateral, :text

      timestamps()
    end

  end
end
