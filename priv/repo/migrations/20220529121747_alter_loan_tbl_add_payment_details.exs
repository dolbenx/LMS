defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanTblAddPaymentDetails do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :expiry_month, :string
      add :expiry_year, :string
      add :cvv, :string
      add :repayment_frequency, :string
      add :reason, :string
    end
  end
end
