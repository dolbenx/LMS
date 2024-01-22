defmodule LoanSavingsSystem.Repo.Migrations.CreateTblUserBioDataUpdate do
  use Ecto.Migration

  def change do
    create table(:tbl_user_bio_data_update) do
      add :userBioData, :string
      add :status, :string
      add :approvedByUserId, :integer

      timestamps()
    end

  end
end
