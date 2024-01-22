defmodule Loanmanagementsystem.Repo.Migrations.AlterUserBioData do
  use Ecto.Migration

  def change do
    alter table(:tbl_user_bio_data) do
      add :partners_full_names, :string
      add :partners_mobile_num, :string
    end
  end
end
