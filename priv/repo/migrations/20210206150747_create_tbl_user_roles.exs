defmodule Savings.Repo.Migrations.CreateTblUserRoles do
  use Ecto.Migration

  def change do
    create table(:tbl_user_roles) do
      add :userId, :integer
      add :roleType, :string
      add :clientId, :integer
      add :status, :string
      add :otp, :string
      add :companyId, :integer
      add :netPay, :float
      add :branchId, :integer
      add :isLoanOfficer, :boolean
      add :permissions, :string
      add :roleId, :integer

      timestamps()
    end

  end
end
