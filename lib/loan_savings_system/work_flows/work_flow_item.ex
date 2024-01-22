defmodule LoanSavingsSystem.WorkFlows.WorkFlowItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_workflow_items" do
    field :actionTaken, :string
    field :branchId, :integer
    field :createdByUserId, :integer
    field :createdByUserRoleId, :integer
    field :entityId, :integer
    field :entityType, :string
    field :notes, :string
    field :offTakerId, :integer
    field :status, :string
    field :workFlowId, :integer
    field :workflowItemRecipientUserId, :integer
    field :workflowItemRecipientUserRoleId, :integer
    field :currentWorkflowPosition, :integer

    timestamps()
  end

  @doc false
  def changeset(work_flow_item, attrs) do
    work_flow_item
    |> cast(attrs, [:currentWorkflowPosition, :workFlowId, :createdByUserId, :workflowItemRecipientUserId, :createdByUserRoleId, :workflowItemRecipientUserRoleId, :branchId, :entityId, :entityType, :status, :actionTaken, :notes, :offTakerId])
    |> validate_required([:workFlowId, :createdByUserId, :workflowItemRecipientUserId, :createdByUserRoleId, :workflowItemRecipientUserRoleId, :branchId, :entityId, :entityType, :status, :actionTaken, :notes, :offTakerId])
  end
  def changesetForUpdate(work_flow, attrs) do
    work_flow
    |> cast(attrs, [:currentWorkflowPosition, :workFlowId, :createdByUserId, :workflowItemRecipientUserId, :createdByUserRoleId, :workflowItemRecipientUserRoleId, :branchId, :entityId, :entityType, :status, :actionTaken, :notes, :offTakerId])
  end
end
