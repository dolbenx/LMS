defmodule LoanSavingsSystem.Divestments.DivestmentTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_divestment_transactions" do
    field :amountDivested, :float
    field :clientId, :integer
    field :divestmentId, :integer
    field :interestAccrued, :float
    field :transactionId, :integer
    field :userId, :integer
    field :userRoleId, :integer

    timestamps()
  end

  @doc false
  def changeset(divestment_transaction, attrs) do
    divestment_transaction
    |> cast(attrs, [:divestmentId, :transactionId, :amountDivested, :interestAccrued, :userId, :userRoleId, :clientId])
    |> validate_required([:divestmentId, :transactionId, :amountDivested, :interestAccrued, :userId, :userRoleId, :clientId])
  end
end
