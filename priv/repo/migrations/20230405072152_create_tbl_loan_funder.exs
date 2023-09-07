defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanFunder do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_funder) do
      add :totalbalance, :float
      add :totalinterest_accumulated, :float
      add :funderID, :integer
      add :totalAmountFunded, :float
      add :status, :string
      add :payment_mode, :string
      add :funder_type, :string

      timestamps()
    end

  end
end
