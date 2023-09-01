defmodule Loanmanagementsystem.Maintenance.Province do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_province" do
    field :countryId, :integer
    field :countryName, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(province, attrs) do
    province
    |> cast(attrs, [:countryId, :countryName, :name])
    |> validate_required([:countryId, :countryName, :name])
  end
end
