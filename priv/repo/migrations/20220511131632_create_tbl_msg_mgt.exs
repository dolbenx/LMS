defmodule Loanmanagementsystem.Repo.Migrations.CreateTblMsgMgt do
  use Ecto.Migration

  def change do
    create table(:tbl_msg_mgt) do
      add :msg_type, :string
      add :msg, :string
      add :status, :string

      timestamps()
    end
  end
end
