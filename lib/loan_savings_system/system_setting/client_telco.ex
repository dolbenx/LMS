defmodule LoanSavingsSystem.SystemSetting.ClientTelco do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_client_telco" do
    field :accountVersion, :float
    field :clientId, :integer
    field :telcoId, :integer
    field :domain, :string
    field :ussdShortCode, :string

    timestamps()
  end

  @doc false
  def changeset(client_telco, attrs) do
    client_telco
    |> cast(attrs, [:telcoId, :domain, :clientId, :accountVersion, :ussdShortCode])
    |> validate_required([:telcoId, :domain, :clientId, :accountVersion, :ussdShortCode])
  end
end
