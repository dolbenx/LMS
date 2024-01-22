defmodule LoanSystem.Repo.Migrations.CreateTblCompanies do
  use Ecto.Migration

  def change do
    create table(:tbl_companies) do
      add :email, :string
      add :phone, :string
      add :company_name, :string
      add :tpin_no, :string
      add :city, :string
      add :country, :string
      add :date_of_incorporation, :string
      add :company_id, :string
      add :address, :string
      add :status, :string
      add :company_file_name, :string
      add :loan_limit, :string
      add :product_code, :string
      add :payday, :integer
      timestamps()
    end

  end
end
