defmodule Loanmanagementsystem.Repo.Migrations.CreateTblMerchantDevice do
  use Ecto.Migration

  def change do
    create table(:tbl_merchant_device) do
      add :deviceName, :string
      add :deviceType, :string
      add :deviceModel, :string
      add :deviceAgentLine, :string
      add :deviceIMEI, :string
      add :merchantId, :integer
      add :status, :string

      timestamps()
    end
  end
end
