defmodule Loanmanagementsystem.Maintenance.Bank do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_banks" do
    field :acronym, :string
    field :approved_by, :integer
    field :bank_address, :string
    field :bank_code, :string
    field :bank_descrip, :string
    field :bank_name, :string
    field :country_id, :integer
    field :created_by, :integer
    field :district_id, :integer
    field :process_branch, :string
    field :province_id, :integer
    field :status, :string
    field :swift_code, :string

    timestamps()
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [:acronym, :bank_code, :bank_descrip, :process_branch, :swift_code, :bank_name, :status, :country_id, :province_id, :district_id, :bank_address, :approved_by, :created_by])
    |> validate_required([:acronym, :bank_code, :swift_code, :bank_name, :status, :country_id, :province_id, :district_id, :created_by])
  end
end
