defmodule Loanmanagementsystem.Maintenance.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_branchs" do
    field :"", :integer
    field :approved_by, :integer
    field :bank_id, :string
    field :branch_address, :string
    field :branch_code, :string
    field :branch_name, :string
    field :city_id, :integer
    field :country_id, :integer
    field :created_by, :integer
    field :district_id, :integer
    field :is_default_ussd_branch, :boolean, default: false
    field :province_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:branch_code, :branch_name, :bank_id, :"", :is_default_ussd_branch, :status, :country_id, :province_id, :city_id, :district_id, :branch_address, :approved_by, :created_by])
    |> validate_required([:branch_code, :branch_name, :bank_id, :"", :is_default_ussd_branch, :status, :country_id, :province_id, :city_id, :district_id, :branch_address, :approved_by, :created_by])
  end
end
