defmodule Savings.Transactions.Transaction do
  @derive {Jason.Encoder, only: [:newTotalBalance, :transactionDetail, :accountId, :carriedOutByUserId, :carriedOutByUserRoleId, :isReversed, :orderRef, :productId, :productType, :referenceNo, :requestData, :responseData, :status, :totalAmount, :transactionType, :userId, :userRoleId]}

  use Ecto.Schema
  import Ecto.Changeset


  schema "tbl_transactions" do
    field :accountId, :integer
    field :carriedOutByUserId, :integer
    field :carriedOutByUserRoleId, :integer
    field :isReversed, :boolean, default: false
    field :orderRef, :string
    field :productId, :integer
    field :productType, :string
    field :referenceNo, :string
    field :requestData, :string
    field :responseData, :string
    field :status, :string
    field :totalAmount, :float
    field :transactionType, :string
    field :userId, :integer
    field :userRoleId, :integer
    field :transactionTypeEnum, :string
    field :transactionDetail, :string
    field :newTotalBalance, :float
    field :customerName, :string
    field :currencyDecimals, :integer
    field :currency, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:currencyDecimals, :currency, :customerName, :newTotalBalance, :transactionDetail, :accountId, :totalAmount, :productId, :productType, :userId, :userRoleId, :referenceNo, :orderRef, :transactionType, :transactionTypeEnum, :status, :isReversed, :requestData, :responseData, :carriedOutByUserId, :carriedOutByUserRoleId])
    |> validate_required([:accountId, :totalAmount, :productId, :productType, :userId, :userRoleId, :referenceNo, :orderRef, :transactionType, :transactionTypeEnum, :status, :isReversed, :requestData, :responseData, :carriedOutByUserId, :carriedOutByUserRoleId])
  end

  def changesetForUpdate(transaction, attrs) do
    transaction
    |> cast(attrs, [:currencyDecimals, :currency, :customerName, :newTotalBalance, :transactionDetail, :accountId, :totalAmount, :productId, :productType, :userId, :userRoleId, :referenceNo, :orderRef, :transactionType, :transactionTypeEnum, :status, :isReversed, :requestData, :responseData, :carriedOutByUserId, :carriedOutByUserRoleId])
  end

  defmodule Localtime do
    def autogenerate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
  end


end
