defmodule LoanSystem.Repo.Migrations.CreateTblStaff do
  use Ecto.Migration

  def change do
    create table(:tbl_staff) do
      add :first_name, :string
      add :last_name, :string
      add :other_name, :string
      add :email, :string, null: false
      add :phone, :string
      add :gender, :string
      add :status, :string
      add :city, :string
      add :country, :string
      add :company_id, :integer
      add :address, :string
      add :id_no, :string
      add :id_type, :string
      add :account_no, :string
      add :branch_id, :integer
      add :staff_file_name, :string
      add :loan_limit, :string



      timestamps()
    end

    create unique_index(:tbl_staff, [:email], name: :unique_email)
    create unique_index(:tbl_staff, [:phone], name: :unique_phone)
    create unique_index(:tbl_staff, [:id_no], name: :unique_id_no)

  end
end
