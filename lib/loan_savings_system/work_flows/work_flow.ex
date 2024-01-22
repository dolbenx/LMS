defmodule LoanSavingsSystem.WorkFlows.WorkFlow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_workflows" do
    field :branchId, :integer
    field :createdByUserId, :integer
    field :createdByUserRoleId, :integer
    field :deletedAt, :date
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(work_flow, attrs) do
    work_flow
    |> cast(attrs, [:name, :createdByUserId, :createdByUserRoleId, :branchId, :status, :deletedAt])
    |> validate_required([:name, :createdByUserId, :createdByUserRoleId, :branchId, :status, :deletedAt])
  end
end
