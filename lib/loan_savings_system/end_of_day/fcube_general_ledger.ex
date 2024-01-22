defmodule LoanSavingsSystem.EndOfDay.FcubeGeneralLedger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fcube_general_ledger" do
    field :account_name, :string
    field :gl_account_no, :string

    timestamps()
  end

  @doc false
  def changeset(fcube_general_ledger, attrs) do
    fcube_general_ledger
    |> cast(attrs, [:account_name, :gl_account_no])
    |> validate_required([:account_name, :gl_account_no])
  end
end
