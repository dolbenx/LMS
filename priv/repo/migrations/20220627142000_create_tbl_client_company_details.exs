defmodule Loanmanagementsystem.Repo.Migrations.CreateTblClientCompanyDetails do
  use Ecto.Migration

  def change do
    create table(:tbl_client_company_details) do
      add :approval_trail, :string
      add :auth_level, :integer
      add :company_name, :string
      add :company_phone, :string
      add :contact_email, :string
      add :createdByUserId, :integer
      add :createdByUserRoleId, :integer
      add :registration_number, :string
      add :status, :string
      add :taxno, :string
      add :company_registration_date, :date
      add :company_account_number, :string
      add :bank_id, :integer
      add :company_account_name, :string
      add :company_department, :string
      add :company_bank_name, :string

      timestamps()
    end
  end
end
