defmodule Loanmanagementsystem.Repo.Migrations.ModifyTblClientCompanyDetails do
  use Ecto.Migration

  def change do
    alter table(:tbl_client_company_details) do
      add :userId, :integer

    end
  end
end
