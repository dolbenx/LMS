defmodule Loanmanagementsystem.Repo.Migrations.CreateTblPaymentType do
  use Ecto.Migration

  def change do
    create table(:tbl_payment_type) do
      add :payment_type_description, :string
      add :system_id, :string

      timestamps()
    end
  end
end
