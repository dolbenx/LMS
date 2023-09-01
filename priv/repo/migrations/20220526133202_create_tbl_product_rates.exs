defmodule Loanmanagementsystem.Repo.Migrations.CreateTblProductRates do
  use Ecto.Migration

  def change do
    create table(:tbl_product_rates) do
      add :product_id, :integer
      add :product_name, :string
      add :tenor, :integer
      add :repayment, :string
      add :interest_rates, :float
      add :processing_fee, :float
      add :status, :string

      timestamps()
    end
  end
end
