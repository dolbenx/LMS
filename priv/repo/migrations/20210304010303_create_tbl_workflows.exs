defmodule LoanSavingsSystem.Repo.Migrations.CreateTblWorkflows do
  use Ecto.Migration

  def change do
    create table(:tbl_workflows) do
      add :workFlowId, :integer
      add :createdByUserId, :integer
      add :workflowItemRecipientUserId, :integer
      add :createdByUserRoleId, :integer
      add :workflowItemRecipientUserRoleId, :integer
      add :branchId, :integer
      add :entityId, :integer
      add :entityType, :string
      add :status, :string
      add :actionTaken, :string
      add :notes, :string
      add :offTakerId, :integer

      timestamps()
    end

  end
end
