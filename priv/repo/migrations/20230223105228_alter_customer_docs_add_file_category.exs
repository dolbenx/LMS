defmodule Loanmanagementsystem.Repo.Migrations.AlterCustomerDocsAddFileCategory do
  use Ecto.Migration

  def change do
    alter table(:tbl_client_documents) do
      add :file_category, :string

    end
  end
end
