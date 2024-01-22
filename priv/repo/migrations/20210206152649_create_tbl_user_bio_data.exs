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
      add :clientId, :integer

      timestamps()
    end

    create unique_index(:tbl_user_bio_data, [:emailAddress], name: :unique_emailAddress)
    create unique_index(:tbl_user_bio_data, [:mobileNumber], name: :unique_mobileNumber)
    create unique_index(:tbl_user_bio_data, [:meansOfIdentificationNumber], name: :unique_meansOfIdentificationNumber)

  end
end
