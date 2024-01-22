defmodule LoanSavingsSystem.Repo.Migrations.CreateTblEmployeeLoanApplication do
  use Ecto.Migration

  def change do
    create table(:tbl_employee_loan_application) do
      add :orgcode, :string
      add :vendorcode, :string
      add :tag, :string
      add :conversationid, :string
      add :custtype, :string
      add :customerid, :string
      add :branchcode, :string
      add :nrc, :string
      add :titleid, :integer
      add :firstname, :string
      add :middlename, :string
      add :lastname, :string
      add :dob, :date
      add :genderid, :integer
      add :maritalstatusid, :integer
      add :address1, :string
      add :districtid1, :integer
      add :provinceid1, :integer
      add :countryid1, :integer
      add :postalcode1, :string
      add :address2, :string
      add :districtid2, :integer
      add :provinceid2, :integer
      add :countryid2, :integer
      add :postalcode2, :string
      add :homephone, :string
      add :workphone, :string
      add :mobileno, :string
      add :emailid, :string
      add :division, :string
      add :nationalityid, :integer
      add :passportno, :string
      add :drivinglicenseno, :string
      add :bankaccountno, :string
      add :bankname, :string
      add :bankbranch, :string
      add :bankaccounttype, :string
      add :bankaccountname, :string
      add :employercode, :string
      add :employeeid, :string
      add :employmenttypeid, :integer
      add :employementstartdate, :date
      add :contractenddate, :date
      add :employerproductmapid, :string
      add :loanamount, :decimal
      add :loandate, :date
      add :isforceclosur, :string
      add :forceclosureloanid, :string
      add :forceclosuredate, :date
      add :loantypeid, :integer
      add :loanpurposeid, :integer
      add :occupation, :string
      add :ispayoff, :string
      add :payoffaccountnumber, :string
      add :payoffmode, :string
      add :payoffbranch, :string
      add :payoffamount, :decimal
      add :payoffinstitution, :string
      add :kinnrcid, :string
      add :kintitleid, :integer
      add :kinfirstname, :string
      add :kinmiddlename, :string
      add :kinlastname, :string
      add :kindob, :date
      add :kinmaritalstatusid, :integer
      add :kingenderid, :integer
      add :kinrelationshipid, :integer
      add :kinplaceofwork, :string
      add :kinoccupation, :string
      add :kintelephonenumber, :string
      add :kinmobilenumber, :string
      add :salarycomponent, :string
      add :amount, :decimal
      add :salarycomponenttypeid, :integer
      add :doctypeid, :integer
      add :document, :string
      add :document_doccontent, :string

      timestamps()
    end

  end
end
