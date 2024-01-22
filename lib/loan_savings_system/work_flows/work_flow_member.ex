defmodule LoanSavingsSystem.WorkFlows.WorkFlowMember do
    @derive {Jason.Encoder, only: [:workFlowId, :userRoleId, :userId, :branchId, :orderPosition, :deletedAt]}
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_workflow_members" do
    field :branchId, :integer
    field :deletedAt, :date
    field :orderPosition, :integer
    field :userId, :integer
    field :userRoleId, :integer
    field :workFlowId, :integer

    timestamps()
  end

  @doc false
  def changeset(work_flow_member, attrs) do
    work_flow_member
    |> cast(attrs, [:workFlowId, :userRoleId, :userId, :branchId, :orderPosition, :deletedAt])
    |> validate_required([:workFlowId, :userRoleId, :userId, :branchId, :orderPosition, :deletedAt])
  end
end
