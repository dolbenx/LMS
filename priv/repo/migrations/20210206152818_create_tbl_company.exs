defmodule LoanSavingsSystem.Repo.Migrations.CreateTblCompany do
  use Ecto.Migration

  def change do
    create table(:tbl_company) do
        add :companyName, :string
        add :contactPhone, :string
        add :registrationNumber, :string
        add :taxNo, :string
        add :contactEmail, :string
        add :isEmployer, :boolean
        add :isSme, :boolean
        add :isOffTaker, :boolean
        add :createdByUserId, :integer
        add :createdByUserRoleId, :integer
        add :status, :string

      timestamps()
    end

  end
end
