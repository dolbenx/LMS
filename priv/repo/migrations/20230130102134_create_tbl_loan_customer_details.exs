defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanCustomerDetails do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_customer_details) do
      add :customer_id, :integer
      add :firstname, :string
      add :surname, :string
      add :othername, :string
      add :id_type, :string
      add :id_number, :string
      add :gender, :string
      add :marital_status, :string
      add :cell_number, :string
      add :email, :string
      add :dob, :string
      add :residential_address, :string
      add :landmark, :string
      add :town, :string
      add :province, :string
      add :reference_no, :string


      timestamps()
    end

  end
end
