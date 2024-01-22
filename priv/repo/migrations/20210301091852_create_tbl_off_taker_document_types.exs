defmodule LoanSavingsSystem.Repo.Migrations.CreateTblOffTakerDocumentTypes do
  use Ecto.Migration

  def change do
    create table(:tbl_off_taker_document_types) do
      add :companyId, :integer
      add :documentTypeId, :integer

      timestamps()
    end

  end
end
