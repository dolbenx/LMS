defmodule Loanmanagementsystem.Repo.Migrations.CreateTblProductCharges do
  use Ecto.Migration

  def change do
    create table(:tbl_product_charges) do
      add :product_id, :integer
      add :charge_id, :integer
      add :status, :string

      timestamps()
    end

  end
end
