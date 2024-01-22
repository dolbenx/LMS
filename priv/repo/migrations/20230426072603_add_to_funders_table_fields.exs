defmodule Loanmanagementsystem.Repo.Migrations.AddToFundersTableFields do
  use Ecto.Migration

  def up do
    alter table(:tbl_loan_funder) do
      add :funder_type, :string
    end
  end

  def down do
    alter table(:tbl_loan_funder) do
      remove :funder_type
    end
  end
end
