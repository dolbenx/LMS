defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCompany do
  use Ecto.Migration

  def change do
    create table(:tbl_company) do
      add :companyName, :string
      add :companyPhone, :string
      add :registrationNumber, :string
      add :taxno, :string
      add :contactEmail, :string
      add :isEmployer, :boolean, default: false, null: false
      add :isSme, :boolean, default: false, null: false
      add :isOfftaker, :boolean, default: false, null: false
      add :createdByUserId, :integer
      add :createdByUserRoleId, :integer
      add :status, :string
      add :approval_trail, :string
      add :auth_level, :integer
      add :companyRegistrationDate, :date
      add :companyAccountNumber, :string
      add :bank_id, :integer
      add :user_bio_id, :integer

      timestamps()
    end
  end
end
