defmodule Loanmanagementsystem.Maintenance.District do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_district" do
    field :approved_by, :integer
    field :country_id, :integer
    field :created_by, :integer
    field :name, :string
    field :province_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(district, attrs) do
    district
    |> cast(attrs, [:name, :country_id, :province_id, :status, :approved_by, :created_by])
    |> validate_required([:name, :country_id, :province_id, :status, :created_by])
  end
end
