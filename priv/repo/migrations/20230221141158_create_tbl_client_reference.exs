defmodule Loanmanagementsystem.Repo.Migrations.CreateTblClientReference do
  use Ecto.Migration

  def change do
    create table(:tbl_client_reference) do
      add :customer_id, :integer
      add :name, :string
      add :contact_no, :string
      add :status, :string

      timestamps()
    end

  end
end
