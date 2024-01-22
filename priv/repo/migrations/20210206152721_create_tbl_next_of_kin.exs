defmodule LoanSavingsSystem.Repo.Migrations.CreateTblNextOfKin do
  use Ecto.Migration

  def change do
    create table(:tbl_next_of_kin) do
      add :firstName, :string
      add :lastName, :string
      add :otherName, :string
      add :addressLine1, :string
      add :addressLine2, :string
      add :city, :string
      add :districtId, :integer
      add :districtName, :string
      add :provinceId, :integer
      add :provinceName, :string
      add :accountId, :integer
      add :userId, :integer
      add :clientId, :integer
      add :otp, :string
      add :email, :string
      add :phoneNumber, :string
      add :telephonenumber, :string
      add :occupation, :string
      add :placeofwork, :string
      add :relationship_id, :integer
      add :gender_id, :integer
      add :marital_status_id, :integer
      add :title_id, :integer
      add :dob, :date

      timestamps()
    end

  end
end
