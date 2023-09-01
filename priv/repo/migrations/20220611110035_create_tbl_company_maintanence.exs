defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCompanyMaintanence do
  use Ecto.Migration

  def change do
    create table(:tbl_company_maintanence) do
      add :company_name, :string
      add :company_reg_no, :string
      add :company_logo, :text
      add :tpin, :string
      add :currency, :string
      add :country, :string
      add :town, :string
      add :address, :string
      add :phone_no, :string

      timestamps()
    end
  end
end
