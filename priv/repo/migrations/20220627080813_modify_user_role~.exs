defmodule :"Elixir.Loanmanagementsystem.Repo.Migrations.ModifyUserRole~" do
  use Ecto.Migration

  def up do
    alter table(:tbl_user_roles) do
      add :client_type, :string
    end
  end

  def down do
    alter table(:tbl_user_roles) do
      remove :client_type
    end
  end
end
