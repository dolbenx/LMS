defmodule Loanmanagementsystem.Employment.Personal_Bank_Details do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_personal_bank_details" do
    field :accountName, :string
    field :accountNumber, :string
    field :bankName, :string
    field :branchName, :string
    field :upload_bank_statement, :string
    field :userId, :integer
    field :bank_id, :integer
    field :mobile_number, :string

    timestamps()
  end

  @doc false
  def changeset(personal__bank__details, attrs) do
    personal__bank__details
    |> cast(attrs, [
      :bankName,
      :branchName,
      :accountNumber,
      :accountName,
      :upload_bank_statement,
      :userId,
      :bank_id,
      :mobile_number
    ])
    # |> validate_required([:bankName, :branchName, :accountNumber, :accountName, :userId, :bank_id, :mobile_number])
  end
end
