defmodule LoanSystem.Repo.Migrations.CreateTblProducts do
  use Ecto.Migration

  def change do
    create table(:tbl_products) do
      add :name, :string
      add :code, :string
      add :details, :string
      add :currency, :string
      add :currency_decimals, :string
      add :annual_interest, :string
      add :fixed_period_days, :string
      add :year_length_days, :string
      add :min_balance_required, :string
      add :withdrawal_fee_amount, :string
      add :withdrawal_fee_transfer_to_mobile, :string
      add :deposit_fee_amount, :string
      add :days_to_inactive, :string
      add :days_to_dormancy, :string
      add :status, :string


      timestamps()
    end

  end
end
