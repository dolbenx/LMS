defmodule LoanSavingsSystem.Repo.Migrations.CreateTblSmeLoanApplication do
  use Ecto.Migration

  def change do
    create table(:tbl_sme_loan_application) do
      add :orgcode, :string
      add :vendorcode, :string
      add :tag, :string
      add :conversationid, :string
      add :offtakerid, :string
      add :financetype, :integer
      add :registrationno, :string
      add :customername, :string
      add :branch, :string
      add :invoiceno, :string
      add :invoicedate, :date
      add :invoiceexpirydate, :date
      add :invoicevalue, :decimal
      add :invoicedetails, :string
      add :invoicedoc, :string
      add :productcode, :string
      add :loanamount, :decimal
      add :Loandate, :date
      add :Loanpurpose, :string
      add :Guarantor, :string
      add :coldocumentname, :string
      add :coldoc, :string
      add :coldetail, :string
      add :collateralvalue, :decimal
      add :appraisedvalue, :decimal
      add :documenttype, :integer
      add :documentdetail, :string
      add :loandoc, :string
      add :fininstitutionname, :string
      add :facility, :decimal
      add :exposure, :string
      add :maturitydate, :date

      timestamps()
    end

  end
end
