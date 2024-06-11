defmodule Loanmanagementsystem.Repo.Migrations.CreateTblTitles do
  use Ecto.Migration

  def change do
    create table(:tbl_titles) do
      add :title, :string
      add :description, :string
      add :status, :string
      add :updater, :integer
      add :maker, :integer

      timestamps()
    end
  end
end
