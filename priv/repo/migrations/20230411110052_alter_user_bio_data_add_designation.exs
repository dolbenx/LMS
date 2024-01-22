defmodule Loanmanagementsystem.Repo.Migrations.AlterUserBioDataAddDesignation do
  use Ecto.Migration

  def change do
    alter table(:tbl_user_bio_data) do
      add :designation, :string
    end
  end
end
