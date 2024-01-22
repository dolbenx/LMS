defmodule LoanSystem.Repo.Migrations.CreateTblSystemParams do
  use Ecto.Migration

  def change do
    create table(:tbl_system_params) do
      add :pacra_number, :string
      add :company_description, :string
      add :company_logo, :string
      add :company_name, :string
      add :address, :string

      timestamps()
    end
  end
end
