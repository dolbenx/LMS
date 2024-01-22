defmodule Loanmanagementsystem.Companies.SmeOfftaker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_sme_offtaker" do
    field :contract_date, :date
    field :end_contract_date, :date
    field :offtakerId, :integer
    field :smeId, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(sme_offtaker, attrs) do
    sme_offtaker
    |> cast(attrs, [:smeId, :offtakerId, :status, :contract_date, :end_contract_date])
    # |> validate_required([:smeId, :offtakerId, :status, :contract_date, :end_contract_date])
  end
end
