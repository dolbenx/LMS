defmodule LoanSavingsSystem.SystemSetting.Province do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_province" do
    field :countryId, :integer
    field :countryName, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(province, attrs) do
    province
    |> cast(attrs, [:name, :countryId, :countryName])
    |> validate_required([:name, :countryId, :countryName])
  end
end
