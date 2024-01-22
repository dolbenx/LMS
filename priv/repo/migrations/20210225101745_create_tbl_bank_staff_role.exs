defmodule LoanSavingsSystem.Repo.Migrations.CreateTblBankStaffRole do
  use Ecto.Migration

  def change do
    create table(:tbl_bank_staff_role) do
      add :roleName, :string
      add :permissions, :string

      timestamps()
    end

  end
end
