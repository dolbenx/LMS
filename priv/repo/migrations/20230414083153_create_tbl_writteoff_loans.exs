defmodule Loanmanagementsystem.Repo.Migrations.CreateTblWritteoffLoans do
  use Ecto.Migration

  def change do
    create table(:tbl_writteoff_loans) do
      add :customer_id, :integer
      add :loan_id, :integer
      add :reference_no, :string
      add :client_name, :string
      add :date_of_writtenoff, :date
      add :amount_writtenoff, :float
      add :writtenoff_by, :integer
      add :savings_account, :string

      timestamps()
    end

  end
end
