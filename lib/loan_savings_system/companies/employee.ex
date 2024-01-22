defmodule LoanSavingsSystem.Companies.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_employee" do
    field :companyId, :integer
    field :employerId, :integer
    field :status, :string
    field :userId, :integer
    field :userRoleId, :integer

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:companyId, :employerId, :userRoleId, :userId, :status])
    |> validate_required([:companyId, :employerId, :userRoleId, :userId, :status])
  end
end
