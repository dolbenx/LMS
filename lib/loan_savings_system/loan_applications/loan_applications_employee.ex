defmodule LoanSavingsSystem.LoanApplications.LoanApplicationsEmployee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_employee_loan_application" do
    field :payoffaccountnumber, :string
    field :nrc, :string
    field :bankaccounttype, :string
    field :districtid1, :integer
    field :provinceid2, :integer
    field :kinnrcid, :string
    field :contractenddate, :date
    field :emailid, :string
    field :document, :string
    field :dob, :date
    field :payoffbranch, :string
    field :loandate, :date
    field :lastname, :string
    field :conversationid, :string
    field :employeeid, :string
    field :salarycomponenttypeid, :integer
    field :kinmobilenumber, :string
    field :genderid, :integer
    field :vendorcode, :string
    field :kinplaceofwork, :string
    field :homephone, :string
    field :tag, :string
    field :drivinglicenseno, :string
    field :kingenderid, :integer
    field :bankaccountname, :string
    field :doctypeid, :integer
    field :middlename, :string
    field :document_doccontent, :string
    field :orgcode, :string
    field :kinrelationshipid, :integer
    field :kinmiddlename, :string
    field :forceclosureloanid, :string
    field :salarycomponent, :string
    field :bankaccountno, :string
    field :employmenttypeid, :integer
    field :loanamount, :decimal
    field :ispayoff, :string
    field :workphone, :string
    field :countryid1, :integer
    field :provinceid1, :integer
    field :kinlastname, :string
    field :custtype, :string
    field :payoffmode, :string
    field :kintelephonenumber, :string
    field :districtid2, :integer
    field :loantypeid, :integer
    field :passportno, :string
    field :bankbranch, :string
    field :countryid2, :integer
    field :customerid, :string
    field :address2, :string
    field :nationalityid, :integer
    field :firstname, :string
    field :postalcode2, :string
    field :kindob, :date
    field :address1, :string
    field :postalcode1, :string
    field :kinfirstname, :string
    field :titleid, :integer
    field :loanpurposeid, :integer
    field :kintitleid, :integer
    field :employementstartdate, :date
    field :division, :string
    field :maritalstatusid, :integer
    field :branchcode, :string
    field :payoffinstitution, :string
    field :payoffamount, :decimal
    field :occupation, :string
    field :isforceclosur, :string
    field :bankname, :string
    field :employercode, :string
    field :kinoccupation, :string
    field :mobileno, :string
    field :employerproductmapid, :string
    field :forceclosuredate, :date
    field :kinmaritalstatusid, :integer
    field :amount, :decimal

    timestamps()
  end

  @doc false
  def changeset(loan_applications_employee, attrs) do
    loan_applications_employee
    |> cast(attrs, [:orgcode, :vendorcode, :tag, :conversationid, :custtype, :customerid, :branchcode, :nrc, :titleid, :firstname, :middlename, :lastname, :dob, :genderid, :maritalstatusid, :address1, :districtid1, :provinceid1, :countryid1, :postalcode1, :address2, :districtid2, :provinceid2, :countryid2, :postalcode2, :homephone, :workphone, :mobileno, :emailid, :division, :nationalityid, :passportno, :drivinglicenseno, :bankaccountno, :bankname, :bankbranch, :bankaccounttype, :bankaccountname, :employercode, :employeeid, :employmenttypeid, :employementstartdate, :contractenddate, :employerproductmapid, :loanamount, :loandate, :isforceclosur, :forceclosureloanid, :forceclosuredate, :loantypeid, :loanpurposeid, :occupation, :ispayoff, :payoffaccountnumber, :payoffmode, :payoffbranch, :payoffamount, :payoffinstitution, :kinnrcid, :kintitleid, :kinfirstname, :kinmiddlename, :kinlastname, :kindob, :kinmaritalstatusid, :kingenderid, :kinrelationshipid, :kinplaceofwork, :kinoccupation, :kintelephonenumber, :kinmobilenumber, :salarycomponent, :amount, :salarycomponenttypeid, :doctypeid, :document, :document_doccontent])
    # |> validate_required([:orgcode, :vendorcode, :tag, :conversationid, :custtype, :customerid, :branchcode, :nrc, :titleid, :firstname, :middlename, :lastname, :dob, :genderid, :maritalstatusid, :address1, :districtid1, :provinceid1, :countryid1, :postalcode1, :address2, :districtid2, :provinceid2, :countryid2, :postalcode2, :homephone, :workphone, :mobileno, :emailid, :division, :nationalityid, :passportno, :drivinglicenseno, :bankaccountno, :bankname, :bankbranch, :bankaccounttype, :bankaccountname, :employercode, :employeeid, :employmenttypeid, :employementstartdate, :contractenddate, :employerproductmapid, :loanamount, :loandate, :isforceclosur, :forceclosureloanid, :forceclosuredate, :loantypeid, :loanpurposeid, :occupation, :ispayoff, :payoffaccountnumber, :payoffmode, :payoffbranch, :payoffamount, :payoffinstitution, :kinnrcid, :kintitleid, :kinfirstname, :kinmiddlename, :kinlastname, :kindob, :kinmaritalstatusid, :kingenderid, :kinrelationshipid, :kinplaceofwork, :kinoccupation, :kintelephonenumber, :kinmobilenumber, :salarycomponent, :amount, :salarycomponenttypeid, :doctypeid, :document, :document_doccontent])
  end
end
