defmodule Loanmanagementsystem.Repo.Migrations.CreateTblClassification do
  use Ecto.Migration

  def change do
    create table(:tbl_classification) do
      add :classification, :string
      add :loan_minimum, :float
      add :loan_maximum, :float
      add :status, :string

      timestamps()
    end
  end
end
