defmodule Loanmanagementsystem.Repo.Migrations.AddingCompanyIdToTblAddressDetails do
  use Ecto.Migration

  def up do
    alter table(:tbl_address_details) do
      add :company_id, :integer
    end
  end

  def down do
    alter table(:tbl_address_details) do
      remove :company_id, :integer
    end
  end
end
