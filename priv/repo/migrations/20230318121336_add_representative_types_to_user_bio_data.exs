defmodule Loanmanagementsystem.Repo.Migrations.AddRepresentativeTypesToUserBioData do
  use Ecto.Migration

  def up do
    alter table(:tbl_user_bio_data) do
      add :representative_1, :boolean
      add :representative_2, :boolean
    end
  end

  def down do
    alter table(:tbl_user_bio_data) do
      remove :representative_1, :boolean
      remove :representative_2, :boolean
    end
  end
end
