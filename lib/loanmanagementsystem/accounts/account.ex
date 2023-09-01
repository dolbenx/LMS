defmodule Loanmanagementsystem.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_account" do
    field :accountNo, :string
    field :clientId, :integer
    field :status, :string
    field :userId, :integer
    field :mobile_number, :string
    field :userRoleId, :integer
    field :branchId, :integer
    field :accountType, :string
    field :pin, :string
    field :password_fail_count, :integer
    field :securityQuestionAnswer, :string
    field :securityQuestionAnswerId, :integer
    field :security_question_fail_count, :integer
    field :telegram_id, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :accountNo,
      :clientId,
      :status,
      :userId,
      :mobile_number,
      :userRoleId,
      :branchId,
      :accountType,
      :pin,
      :password_fail_count,
      :securityQuestionAnswer,
      :securityQuestionAnswerId,
      :security_question_fail_count,
      :telegram_id
    ])
    |> validate_required([
      :accountNo,
      :clientId,
      :status,
      :userId,
      :mobile_number,
      :userRoleId,
      :branchId,
      :accountType,
      :pin,
      :password_fail_count,
      :securityQuestionAnswer,
      :securityQuestionAnswerId,
      :security_question_fail_count
    ])
  end

  @doc false
  def changesetForUpdate(account, attrs) do
    account
    |> cast(attrs, [
      :accountNo,
      :clientId,
      :status,
      :userId,
      :mobile_number,
      :userRoleId,
      :branchId,
      :accountType,
      :pin,
      :password_fail_count,
      :securityQuestionAnswer,
      :securityQuestionAnswerId,
      :security_question_fail_count,
      :telegram_id
    ])
  end
end
