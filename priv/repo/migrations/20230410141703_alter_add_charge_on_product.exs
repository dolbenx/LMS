defmodule Loanmanagementsystem.Repo.Migrations.AlterAddChargeOnProduct do
  use Ecto.Migration

  def change do
    alter table(:tbl_products) do
      add :insurance, :float
      add :proccessing_fee, :float
      add :crb_fee, :float
    end
  end
end
