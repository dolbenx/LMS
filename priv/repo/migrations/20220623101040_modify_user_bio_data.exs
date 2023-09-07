defmodule Loanmanagementsystem.Repo.Migrations.ModifyUserBioData do
  use Ecto.Migration

  def up do
    alter table(:tbl_user_bio_data) do
      add :employment_status, :string
      add :client_type, :string
      add :disability_detail, :string
      add :disability_status, :string
      add :age, :integer
    end
  end

  def down do
    alter table(:tbl_user_bio_data) do
      remove :employment_status
      remove :client_type
      remove :disability_detail
      remove :disability_status
      remove :age
    end
  end
end
