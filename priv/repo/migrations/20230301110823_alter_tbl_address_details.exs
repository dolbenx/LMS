defmodule Loanmanagementsystem.Repo.Migrations.AlterTblAddressDetails do
  use Ecto.Migration

  def change do
    alter table(:tbl_address_details) do
      add :land_mark, :string
    end
  end
end
