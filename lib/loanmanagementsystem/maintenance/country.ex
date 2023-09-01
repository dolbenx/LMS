defmodule Loanmanagementsystem.Maintenance.Country do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_country" do
    field :country_file_name, :string
    field :name, :string
    field :code, :string

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :country_file_name, :code])
    |> validate_required([:name, :country_file_name, :code])
  end
end
