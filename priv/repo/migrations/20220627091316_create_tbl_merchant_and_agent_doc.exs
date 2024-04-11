defmodule Loanmanagementsystem.Repo.Migrations.CreateTblMerchantAndAgentDoc do
  use Ecto.Migration

  def change do
    create table(:tbl_merchant_and_agent_doc) do
      add :docName, :string
      add :userID, :integer
      add :companyID, :integer
      add :taxNo, :string
      add :docType, :string
      add :status, :string
      add :path, :string
      add :file, :string

      timestamps()
    end
  end
end
