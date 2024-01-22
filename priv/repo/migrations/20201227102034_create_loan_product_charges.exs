defmodule LoanSystem.Repo.Migrations.CreateLoanProductCharges do
  use Ecto.Migration

  def change do
    create table(:loan_product_charges) do
      add :loan_product_id, :integer
      add :charge_id, :integer

      timestamps()
    end

  end
end
