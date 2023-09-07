defmodule Loanmanagementsystem.Repo.Migrations.CreateTblSmeOfftaker do
  use Ecto.Migration

  def change do
    create table(:tbl_sme_offtaker) do
      add :smeId, :integer
      add :offtakerId, :integer
      add :status, :string
      add :contract_date, :date
      add :end_contract_date, :date

      timestamps()
    end
  end
end
