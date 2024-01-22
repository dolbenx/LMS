defmodule Loanmanagementsystem.Repo.Migrations.ModifyMerchantsTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_merchant) do
      add :qr_code_name, :string
      add :merchant_number, :string
      add :qr_code_path, :string
      add :user_id, :integer
    end
  end

  def down do
    alter table(:tbl_merchant) do
      remove :qr_code_name
      remove :merchant_number
      remove :qr_code_path
      remove :user_id
    end
  end
end
