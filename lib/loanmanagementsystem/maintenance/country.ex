defmodule Loanmanagementsystem.Maintenance.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_country" do
    field :approved_by, :integer
    field :code, :string
    field :country_file_name, :string
    field :created_by, :integer
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:country_file_name, :name, :code, :status, :approved_by, :created_by])
    |> validate_required([:name, :code, :status, :created_by])
  end
end
