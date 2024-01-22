defmodule LoanSavingsSystem.Repo.Migrations.CreateTblUserBioData do
  use Ecto.Migration

  def change do
    create table(:tbl_user_bio_data) do
      add :firstName, :string
      add :lastName, :string
      add :userId, :integer
      add :otherName, :string
      add :dateOfBirth, :date
      add :meansOfIdentificationType, :string
      add :meansOfIdentificationNumber, :string
      add :title, :string
      add :gender, :string
      add :mobileNumber, :string
      add :emailAddress, :string
      add :idNo, :string
      add :bank_id, :integer
      add :bank_account_number, :string
      add :marital_status, :string
      add :nationality, :string
      add :number_of_dependants, :integer
      add :employee_confirmation, :boolean, default: false, null: false
      add :applicant_declaration, :boolean, default: false, null: false
      add :accept_conditions, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:tbl_user_bio_data, [:emailAddress], name: :unique_emailAddress)
    create unique_index(:tbl_user_bio_data, [:mobileNumber], name: :unique_mobileNumber)

    create unique_index(:tbl_user_bio_data, [:meansOfIdentificationNumber],
             name: :unique_meansOfIdentificationNumber
           )

    create unique_index(:tbl_user_bio_data, [:bank_account_number],
             name: :unique_bank_account_number
           )
  end
end
