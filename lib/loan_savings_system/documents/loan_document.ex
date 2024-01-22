defmodule LoanSavingsSystem.Documents.LoanDocument do
  use Ecto.Schema
  import Ecto.Changeset
  alias LoanSavingsSystem.Documents.LoanDocument
  @timestamps_opts [autogenerate: {LoanDocument.Localtime, :autogenerate, []}]
  schema "tbl_loan_documents" do
    field :documentLocation, :string
    field :documentName, :string
    field :loanId, :integer
    field :updatedByUserId, :integer
    field :updatedByUseroleId, :integer
    field :client_id, :integer
    field :company_id, :integer
    field :loan_application_id, :integer
    field :product_id, :integer
    field :status, :string
    field :offtaker_id, :integer
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(loan_document, attrs) do
    loan_document
    |> cast(attrs, [:path, :offtaker_id, :status, :loanId, :client_id, :company_id, :product_id, :loan_application_id, :documentName, :documentLocation, :updatedByUserId, :updatedByUseroleId])
    # |> validate_required([:documentName, :client_id, :product_id, :loan_application_id, :documentLocation, :updatedByUserId, :updatedByUseroleId])
  end


  defmodule Localtime do
    def autogenerate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
  end
end
