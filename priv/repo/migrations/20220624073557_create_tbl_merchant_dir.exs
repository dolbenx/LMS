defmodule Loanmanagementsystem.Repo.Migrations.CreateTblMerchantDir do
  use Ecto.Migration

  def change do
    create table(:tbl_merchant_dir) do
      add :firstName, :string
      add :lastName, :string
      add :otherName, :string
      add :directorIdentificationnNumber, :string
      add :directorIdType, :string
      add :mobileNumber, :string
      add :emailAddress, :string
      add :status, :string
      add :merchantType, :string
      add :merchantId, :integer

      timestamps()
    end
  end
end
