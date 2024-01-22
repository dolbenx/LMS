defmodule LoanSavingsSystem.Companies.Employer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl" do
    field :_employer, :string
    field :companyId, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(employer, attrs) do
    employer
    |> cast(attrs, [:_employer, :companyId, :status])
    |> validate_required([:_employer, :companyId, :status])
  end
end
