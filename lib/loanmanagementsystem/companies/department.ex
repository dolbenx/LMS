defmodule Loanmanagementsystem.Companies.Department do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_departments" do
    field :companyId, :string
    field :deptCode, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:name, :deptCode, :companyId, :status])
    |> validate_required([:name, :deptCode, :status])
  end
end
