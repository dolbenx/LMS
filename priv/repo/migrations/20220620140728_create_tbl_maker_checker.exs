defmodule Loanmanagementsystem.Repo.Migrations.CreateTblMakerChecker do
  use Ecto.Migration

  def change do
    create table(:tbl_maker_checker) do
      add :module, :string
      add :module_code, :string
      add :maker, :string
      add :checker, :string

      timestamps()
    end
  end
end
