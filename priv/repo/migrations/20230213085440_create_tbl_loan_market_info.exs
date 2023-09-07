defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanMarketInfo do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_market_info) do
      add :customer_id, :integer
      add :reference_no, :string
      add :name_of_market, :string
      add :location_of_market, :string
      add :duration_at_market, :string
      add :type_of_business, :string
      add :name_of_market_leader, :string
      add :mobile_of_market_leader, :string
      add :name_of_market_vice, :string
      add :mobile_of_market_vice, :string
      add :stand_number, :string

      timestamps()
    end

  end
end
