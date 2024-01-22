defmodule Loanmanagementsystem.Repo.Migrations.AlterAddressTable do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :land_mark, :string

    end
  end
end
