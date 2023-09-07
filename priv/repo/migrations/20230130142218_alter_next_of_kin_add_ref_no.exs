defmodule Loanmanagementsystem.Repo.Migrations.AlterNextOfKinAddRefNo do
  use Ecto.Migration

  def change do
    alter table(:tbl_next_of_kin) do
      add :reference_no, :string

    end
  end
end
