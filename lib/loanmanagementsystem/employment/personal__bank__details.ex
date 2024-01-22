defmodule Loanmanagementsystem.Employment.Personal_Bank_Details do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_personal_bank_details" do
    field :accountName, :string
    field :accountNumber, :string
    field :bankName, :string
    field :branchName, :string
    field :upload_bank_statement, :string
    field :mobile_number, :string
    field :mobile_network_operator, :string
    field :userId, :integer
    field :bank_id, :integer

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(personal__bank__details, attrs) do
    personal__bank__details
    |> cast(attrs, [
      :bankName,
      :branchName,
      :accountNumber,
      :accountName,
      :upload_bank_statement,
      :mobile_number,
      :mobile_network_operator,
      :userId,
      :bank_id
    ])
    # |> validate_required([:bankName, :branchName, :accountNumber, :accountName, :userId, :bank_id, :mobile_number])
  end
end
