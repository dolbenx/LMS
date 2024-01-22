defmodule Loanmanagementsystem.Loan.Loan_Colletral_Documents do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_colleteral_documents" do
    field :clientID, :integer
    field :company_id, :integer
    field :docType, :string
    field :file, :string
    field :name, :string
    field :path, :string
    field :reference_no, :string
    field :serialNo, :string
    field :status, :string
    field :userID, :integer

    timestamps()
  end

  @doc false
  def changeset(loan__colletral__documents, attrs) do
    loan__colletral__documents
    |> cast(attrs, [:name, :userID, :file, :company_id, :path, :docType, :clientID, :reference_no, :status, :serialNo])
    # |> validate_required([:name, :userID, :file, :company_id, :path, :docType, :clientID, :reference_no, :status, :serialNo])
  end
end
