defmodule Loanmanagementsystem.Repo.Migrations.CreateTblNextOfKin do
  use Ecto.Migration

  def change do
    create table(:tbl_next_of_kin) do
      add :kin_first_name, :string
      add :kin_last_name, :string
      add :kin_other_name, :string
      add :kin_status, :string
      add :kin_relationship, :string
      add :kin_ID_number, :string
      add :userID, :integer
      add :kin_mobile_number, :string
      add :kin_personal_email, :string
      add :kin_gender, :string
      add :applicant_nrc, :string

      timestamps()
    end

  end
end
