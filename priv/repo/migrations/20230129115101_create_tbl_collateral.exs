defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCollateral do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_collateral) do
      add :customer_id, :integer
      add :name_of_collateral, :string
      add :id_number, :string
      add :color, :string
      add :asset_value, :float
      add :applicant_signature, :text
      add :name_of_witness, :string
      add :witness_signature, :text
      add :cro_staff_name, :string
      add :cro_staff_signature, :text
      add :reference_no, :string
      add :serialNo, :string

      timestamps()
    end

  end
end
