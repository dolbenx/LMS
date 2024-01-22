defmodule Loanmanagementsystem.Repo.Migrations.AlterUserBioAddBranch do
  use Ecto.Migration

  def change do
    alter table(:tbl_user_bio_data) do
      add :branch, :string
    end
  end
end
