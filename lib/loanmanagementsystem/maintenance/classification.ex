defmodule Loanmanagementsystem.Maintenance.Classification do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_classification" do
    field :classification, :string
    field :loan_maximum, :float
    field :loan_minimum, :float
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(classification, attrs) do
    classification
    |> cast(attrs, [:classification, :loan_minimum, :loan_maximum, :status])
    |> validate_required([:classification, :loan_minimum, :loan_maximum, :status])
  end
end
