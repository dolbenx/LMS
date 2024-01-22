defmodule LoanSavingsSystem.LoanApplications.LoanApplicationsSme do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_sme_loan_application" do
    field :invoicedoc, :string
    field :collateralvalue, :decimal
    field :facility, :decimal
    field :Guarantor, :string
    field :conversationid, :string
    field :Loanpurpose, :string
    field :invoicedate, :date
    field :coldocumentname, :string
    field :invoiceno, :string
    field :tag, :string
    field :Loandate, :date
    field :customername, :string
    field :branch, :string
    field :documenttype, :integer
    field :registrationno, :string
    field :appraisedvalue, :decimal
    field :invoiceexpirydate, :date
    field :fininstitutionname, :string
    field :exposure, :string
    field :invoicevalue, :decimal
    field :loandoc, :string
    field :loanamount, :decimal
    field :maturitydate, :date
    field :coldetail, :string
    field :documentdetail, :string
    field :financetype, :integer
    field :productcode, :string
    field :coldoc, :string
    field :invoicedetails, :string
    field :orgcode, :string
    field :offtakerid, :string
    field :vendorcode, :string

    timestamps()
  end

  @doc false
  def changeset(loan_applications_sme, attrs) do
    loan_applications_sme
    |> cast(attrs, [:orgcode, :vendorcode, :tag, :conversationid, :offtakerid, :financetype, :registrationno, :customername, :branch, :invoiceno, :invoicedate, :invoiceexpirydate, :invoicevalue, :invoicedetails, :invoicedoc, :productcode, :loanamount, :Loandate, :Loanpurpose, :Guarantor, :coldocumentname, :coldoc, :coldetail, :collateralvalue, :appraisedvalue, :documenttype, :documentdetail, :loandoc, :fininstitutionname, :facility, :exposure, :maturitydate])
    # |> validate_required([:orgcode, :vendorcode, :tag, :conversationid, :offtakerid, :financetype, :registrationno, :customername, :branch, :invoiceno, :invoicedate, :invoiceexpirydate, :invoicevalue, :invoicedetails, :invoicedoc, :productcode, :loanamount, :Loandate, :Loanpurpose, :Guarantor, :coldocumentname, :coldoc, :coldetail, :collateralvalue, :appraisedvalue, :documenttype, :documentdetail, :loandoc, :fininstitutionname, :facility, :exposure, :maturitydate])
  end
end
