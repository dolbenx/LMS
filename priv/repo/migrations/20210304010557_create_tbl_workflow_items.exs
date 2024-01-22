defmodule LoanSavingsSystem.Repo.Migrations.CreateTblWorkflowItems do
  use Ecto.Migration

  def change do
    create table(:tbl_workflow_items) do
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
      add :currentWorkflowPosition, :integer

      timestamps()
    end

  end
end
