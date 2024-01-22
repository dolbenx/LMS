defmodule LoanSavingsSystem.SystemSetting.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_country" do
    field :name, :string
    field :country_file_name, :string

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
