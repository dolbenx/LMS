defmodule Savings.FixedDeposit.FixedDepositTransaction do
  use Ecto.Schema
  import Ecto.Changeset
   schema "tbl_fixed_deposit_transactions" do
    field :amountDeposited, :float
    field :clientId, :integer
    field :fixedDepositId, :integer
    field :transactionId, :integer
    field :userId, :integer
    field :userRoleId, :integer
    field :status, :string
    # field :productId, :integer

    timestamps()
  end

  @doc false
  def changeset(fixed_deposit_transaction, attrs) do
    fixed_deposit_transaction
    |> cast(attrs, [:status, :fixedDepositId, :transactionId, :clientId, :amountDeposited, :userId, :userRoleId])
    |> validate_required([:fixedDepositId, :transactionId, :clientId, :amountDeposited, :userId, :userRoleId])
  end





  @doc false
  def changesetForUpdate(fixed_deposit_transaction, attrs) do
    fixed_deposit_transaction
    |> cast(attrs, [:status, :fixedDepositId, :transactionId, :clientId, :amountDeposited, :userId, :userRoleId])
  end


end
