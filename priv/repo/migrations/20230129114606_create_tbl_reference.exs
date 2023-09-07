defmodule Loanmanagementsystem.Repo.Migrations.CreateTblReference do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_reference) do
      add :customer_id, :integer
      add :name, :string
      add :contact_no, :string
      add :reference_no, :string

      timestamps()
    end

  end
end
