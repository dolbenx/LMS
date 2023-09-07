defmodule Loanmanagementsystem.Repo.Migrations.CreateTblMerchant do
  use Ecto.Migration

  def change do
    create table(:tbl_merchant) do
      add :merchantType, :string
      add :bankId, :integer
      add :companyName, :string
      add :businessName, :string
      add :businessNature, :string
      add :companyPhone, :string
      add :registrationNumber, :string
      add :taxno, :string
      add :contactEmail, :string
      add :createdByUserId, :integer
      add :createdByUserRoleId, :integer
      add :status, :string
      add :approval_trail, :string
      add :authLevel, :integer
      add :companyRegistrationDate, :date
      add :companyAccountNumber, :string

      timestamps()
    end
  end
end
