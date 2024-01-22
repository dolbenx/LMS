defmodule LoanSavingsSystem.Repo.Migrations.CreateTblWorkflowMembers do
  use Ecto.Migration

  def change do
    create table(:tbl_workflow_members) do
      add :workFlowId, :integer
      add :userRoleId, :integer
      add :userId, :integer
      add :branchId, :integer
      add :orderPosition, :integer
      add :deletedAt, :date

      timestamps()
    end

  end
end
