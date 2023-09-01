defmodule Loanmanagementsystem.Maintenance.Qfin_Brance_maintenance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_qfin_branches" do
    field :branchAddress, :string
    field :branchCode, :string
    field :city, :string
    field :name, :string
    field :province, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(qfin__brance_maintenance, attrs) do
    qfin__brance_maintenance
    |> cast(attrs, [:name, :branchCode, :branchAddress, :city, :province, :status])
    |> validate_required([:name, :branchCode, :branchAddress, :city, :province, :status])
  end
end
