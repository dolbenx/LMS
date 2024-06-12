defmodule Loanmanagementsystem.Maintenance.Province do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_province" do
    field :approved_by, :integer
    field :country_id, :integer
    field :created_by, :integer
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(province, attrs) do
    province
    |> cast(attrs, [:name, :country_id, :status, :approved_by, :created_by])
    |> validate_required([:name, :country_id, :status, :created_by])
  end
end
