defmodule LoanSystem.Repo.Migrations.CreateUssdloanproducts do
  use Ecto.Migration

  def change do
    create table(:ussdloanproducts) do
      add :loan_product_id, :integer
      add :default_interest_rate, :float
      add :default_period, :integer
      add :repayment_count, :integer

      timestamps()
    end

  end
end
