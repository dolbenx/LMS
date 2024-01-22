defmodule Loanmanagementsystem.Repo.Migrations.AlterProductAddRefNo do
  use Ecto.Migration

  def change do
    alter table(:tbl_products) do
      add :reference_id, :integer
      add :reason, :string
    end
  end
end
