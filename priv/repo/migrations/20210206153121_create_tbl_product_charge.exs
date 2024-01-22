defmodule LoanSavingsSystem.Repo.Migrations.CreateTblProductCharge do
  use Ecto.Migration

  def change do
    create table(:tbl_product_charge) do
      add :productId, :integer
      add :chargeId, :integer
      add :chargeWhen, :string

      timestamps()
    end

  end
end
