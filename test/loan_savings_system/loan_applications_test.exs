defmodule LoanSavingsSystem.Loan_applicationsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Loan_applications

  describe "tbl_loan_app" do
    alias LoanSavingsSystem.Loan_applications.Loan_application

    @valid_attrs %{company_id: "some company_id", customer_id: "some customer_id", customer_name: "some customer_name", loan_status: "some loan_status"}
    @update_attrs %{company_id: "some updated company_id", customer_id: "some updated customer_id", customer_name: "some updated customer_name", loan_status: "some updated loan_status"}
    @invalid_attrs %{company_id: nil, customer_id: nil, customer_name: nil, loan_status: nil}

    def loan_application_fixture(attrs \\ %{}) do
      {:ok, loan_application} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan_applications.create_loan_application()

      loan_application
    end

    test "list_tbl_loan_app/0 returns all tbl_loan_app" do
      loan_application = loan_application_fixture()
      assert Loan_applications.list_tbl_loan_app() == [loan_application]
    end

    test "get_loan_application!/1 returns the loan_application with given id" do
      loan_application = loan_application_fixture()
      assert Loan_applications.get_loan_application!(loan_application.id) == loan_application
    end

    test "create_loan_application/1 with valid data creates a loan_application" do
      assert {:ok, %Loan_application{} = loan_application} = Loan_applications.create_loan_application(@valid_attrs)
      assert loan_application.company_id == "some company_id"
      assert loan_application.customer_id == "some customer_id"
      assert loan_application.customer_name == "some customer_name"
      assert loan_application.loan_status == "some loan_status"
    end

    test "create_loan_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan_applications.create_loan_application(@invalid_attrs)
    end

    test "update_loan_application/2 with valid data updates the loan_application" do
      loan_application = loan_application_fixture()
      assert {:ok, %Loan_application{} = loan_application} = Loan_applications.update_loan_application(loan_application, @update_attrs)
      assert loan_application.company_id == "some updated company_id"
      assert loan_application.customer_id == "some updated customer_id"
      assert loan_application.customer_name == "some updated customer_name"
      assert loan_application.loan_status == "some updated loan_status"
    end

    test "update_loan_application/2 with invalid data returns error changeset" do
      loan_application = loan_application_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan_applications.update_loan_application(loan_application, @invalid_attrs)
      assert loan_application == Loan_applications.get_loan_application!(loan_application.id)
    end

    test "delete_loan_application/1 deletes the loan_application" do
      loan_application = loan_application_fixture()
      assert {:ok, %Loan_application{}} = Loan_applications.delete_loan_application(loan_application)
      assert_raise Ecto.NoResultsError, fn -> Loan_applications.get_loan_application!(loan_application.id) end
    end

    test "change_loan_application/1 returns a loan_application changeset" do
      loan_application = loan_application_fixture()
      assert %Ecto.Changeset{} = Loan_applications.change_loan_application(loan_application)
    end
  end

  describe "tbl_sme_loan_application" do
    alias LoanSavingsSystem.LoanApplications.LoanApplicationsSme

    @valid_attrs %{Loan: "some Loan", conversationid: "some conversationid", mix: "some mix", orgcode: "some orgcode", "phx.gen.context": "some phx.gen.context", tag: "some tag", tbl_sme_loan_application: "some tbl_sme_loan_application", vendorcode: "some vendorcode"}
    @update_attrs %{Loan: "some updated Loan", conversationid: "some updated conversationid", mix: "some updated mix", orgcode: "some updated orgcode", "phx.gen.context": "some updated phx.gen.context", tag: "some updated tag", tbl_sme_loan_application: "some updated tbl_sme_loan_application", vendorcode: "some updated vendorcode"}
    @invalid_attrs %{Loan: nil, conversationid: nil, mix: nil, orgcode: nil, "phx.gen.context": nil, tag: nil, tbl_sme_loan_application: nil, vendorcode: nil}

    def loan_applications_sme_fixture(attrs \\ %{}) do
      {:ok, loan_applications_sme} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LoanApplications.create_loan_applications_sme()

      loan_applications_sme
    end

    test "list_tbl_sme_loan_application/0 returns all tbl_sme_loan_application" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert LoanApplications.list_tbl_sme_loan_application() == [loan_applications_sme]
    end

    test "get_loan_applications_sme!/1 returns the loan_applications_sme with given id" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert LoanApplications.get_loan_applications_sme!(loan_applications_sme.id) == loan_applications_sme
    end

    test "create_loan_applications_sme/1 with valid data creates a loan_applications_sme" do
      assert {:ok, %LoanApplicationsSme{} = loan_applications_sme} = LoanApplications.create_loan_applications_sme(@valid_attrs)
      assert loan_applications_sme.Loan == "some Loan"
      assert loan_applications_sme.conversationid == "some conversationid"
      assert loan_applications_sme.mix == "some mix"
      assert loan_applications_sme.orgcode == "some orgcode"
      assert loan_applications_sme.phx.gen.context == "some phx.gen.context"
      assert loan_applications_sme.tag == "some tag"
      assert loan_applications_sme.tbl_sme_loan_application == "some tbl_sme_loan_application"
      assert loan_applications_sme.vendorcode == "some vendorcode"
    end

    test "create_loan_applications_sme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LoanApplications.create_loan_applications_sme(@invalid_attrs)
    end

    test "update_loan_applications_sme/2 with valid data updates the loan_applications_sme" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert {:ok, %LoanApplicationsSme{} = loan_applications_sme} = LoanApplications.update_loan_applications_sme(loan_applications_sme, @update_attrs)
      assert loan_applications_sme.Loan == "some updated Loan"
      assert loan_applications_sme.conversationid == "some updated conversationid"
      assert loan_applications_sme.mix == "some updated mix"
      assert loan_applications_sme.orgcode == "some updated orgcode"
      assert loan_applications_sme.phx.gen.context == "some updated phx.gen.context"
      assert loan_applications_sme.tag == "some updated tag"
      assert loan_applications_sme.tbl_sme_loan_application == "some updated tbl_sme_loan_application"
      assert loan_applications_sme.vendorcode == "some updated vendorcode"
    end

    test "update_loan_applications_sme/2 with invalid data returns error changeset" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert {:error, %Ecto.Changeset{}} = LoanApplications.update_loan_applications_sme(loan_applications_sme, @invalid_attrs)
      assert loan_applications_sme == LoanApplications.get_loan_applications_sme!(loan_applications_sme.id)
    end

    test "delete_loan_applications_sme/1 deletes the loan_applications_sme" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert {:ok, %LoanApplicationsSme{}} = LoanApplications.delete_loan_applications_sme(loan_applications_sme)
      assert_raise Ecto.NoResultsError, fn -> LoanApplications.get_loan_applications_sme!(loan_applications_sme.id) end
    end

    test "change_loan_applications_sme/1 returns a loan_applications_sme changeset" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert %Ecto.Changeset{} = LoanApplications.change_loan_applications_sme(loan_applications_sme)
    end
  end

  describe "tbl_sme_loan_application" do
    alias LoanSavingsSystem.LoanApplications.LoanApplicationsSme

    @valid_attrs %{vendorcode: "some vendorcode", offtakerid: "some offtakerid", orgcode: "some orgcode", invoicedetails: "some invoicedetails", coldoc: "some coldoc", productcode: "some productcode", financetype: 42, documentdetail: "some documentdetail", coldetail: "some coldetail", maturitydate: ~D[2010-04-17], loanamount: "120.5", loandoc: "some loandoc", mix: "some mix", invoicevalue: "120.5", exposure: "some exposure", fininstitutionname: "some fininstitutionname", invoiceexpirydate: ~D[2010-04-17], appraisedvalue: "120.5", registrationno: "some registrationno", tbl_sme_loan_application: "some tbl_sme_loan_application", documenttype: 42, branch: "some branch", customername: "some customername", Loandate: ~D[2010-04-17], tag: "some tag", invoiceno: "some invoiceno", coldocumentname: "some coldocumentname", invoicedate: ~D[2010-04-17], Loanpurpose: "some Loanpurpose", conversationid: "some conversationid", Guarantor: "some Guarantor", "phx.gen.context": "some phx.gen.context", facility: "120.5", collateralvalue: "120.5", invoicedoc: "some invoicedoc", Loan: "some Loan"}
    @update_attrs %{vendorcode: "some updated vendorcode", offtakerid: "some updated offtakerid", orgcode: "some updated orgcode", invoicedetails: "some updated invoicedetails", coldoc: "some updated coldoc", productcode: "some updated productcode", financetype: 43, documentdetail: "some updated documentdetail", coldetail: "some updated coldetail", maturitydate: ~D[2011-05-18], loanamount: "456.7", loandoc: "some updated loandoc", mix: "some updated mix", invoicevalue: "456.7", exposure: "some updated exposure", fininstitutionname: "some updated fininstitutionname", invoiceexpirydate: ~D[2011-05-18], appraisedvalue: "456.7", registrationno: "some updated registrationno", tbl_sme_loan_application: "some updated tbl_sme_loan_application", documenttype: 43, branch: "some updated branch", customername: "some updated customername", Loandate: ~D[2011-05-18], tag: "some updated tag", invoiceno: "some updated invoiceno", coldocumentname: "some updated coldocumentname", invoicedate: ~D[2011-05-18], Loanpurpose: "some updated Loanpurpose", conversationid: "some updated conversationid", Guarantor: "some updated Guarantor", "phx.gen.context": "some updated phx.gen.context", facility: "456.7", collateralvalue: "456.7", invoicedoc: "some updated invoicedoc", Loan: "some updated Loan"}
    @invalid_attrs %{vendorcode: nil, offtakerid: nil, orgcode: nil, invoicedetails: nil, coldoc: nil, productcode: nil, financetype: nil, documentdetail: nil, coldetail: nil, maturitydate: nil, loanamount: nil, loandoc: nil, mix: nil, invoicevalue: nil, exposure: nil, fininstitutionname: nil, invoiceexpirydate: nil, appraisedvalue: nil, registrationno: nil, tbl_sme_loan_application: nil, documenttype: nil, branch: nil, customername: nil, Loandate: nil, tag: nil, invoiceno: nil, coldocumentname: nil, invoicedate: nil, Loanpurpose: nil, conversationid: nil, Guarantor: nil, "phx.gen.context": nil, facility: nil, collateralvalue: nil, invoicedoc: nil, Loan: nil}

    def loan_applications_sme_fixture(attrs \\ %{}) do
      {:ok, loan_applications_sme} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LoanApplications.create_loan_applications_sme()

      loan_applications_sme
    end

    test "list_tbl_sme_loan_application/0 returns all tbl_sme_loan_application" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert LoanApplications.list_tbl_sme_loan_application() == [loan_applications_sme]
    end

    test "get_loan_applications_sme!/1 returns the loan_applications_sme with given id" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert LoanApplications.get_loan_applications_sme!(loan_applications_sme.id) == loan_applications_sme
    end

    test "create_loan_applications_sme/1 with valid data creates a loan_applications_sme" do
      assert {:ok, %LoanApplicationsSme{} = loan_applications_sme} = LoanApplications.create_loan_applications_sme(@valid_attrs)
      assert loan_applications_sme.Loan == "some Loan"
      assert loan_applications_sme.invoicedoc == "some invoicedoc"
      assert loan_applications_sme.collateralvalue == Decimal.new("120.5")
      assert loan_applications_sme.facility == Decimal.new("120.5")
      assert loan_applications_sme.phx.gen.context == "some phx.gen.context"
      assert loan_applications_sme.Guarantor == "some Guarantor"
      assert loan_applications_sme.conversationid == "some conversationid"
      assert loan_applications_sme.Loanpurpose == "some Loanpurpose"
      assert loan_applications_sme.invoicedate == ~D[2010-04-17]
      assert loan_applications_sme.coldocumentname == "some coldocumentname"
      assert loan_applications_sme.invoiceno == "some invoiceno"
      assert loan_applications_sme.tag == "some tag"
      assert loan_applications_sme.Loandate == ~D[2010-04-17]
      assert loan_applications_sme.customername == "some customername"
      assert loan_applications_sme.branch == "some branch"
      assert loan_applications_sme.documenttype == 42
      assert loan_applications_sme.tbl_sme_loan_application == "some tbl_sme_loan_application"
      assert loan_applications_sme.registrationno == "some registrationno"
      assert loan_applications_sme.appraisedvalue == Decimal.new("120.5")
      assert loan_applications_sme.invoiceexpirydate == ~D[2010-04-17]
      assert loan_applications_sme.fininstitutionname == "some fininstitutionname"
      assert loan_applications_sme.exposure == "some exposure"
      assert loan_applications_sme.invoicevalue == Decimal.new("120.5")
      assert loan_applications_sme.mix == "some mix"
      assert loan_applications_sme.loandoc == "some loandoc"
      assert loan_applications_sme.loanamount == Decimal.new("120.5")
      assert loan_applications_sme.maturitydate == ~D[2010-04-17]
      assert loan_applications_sme.coldetail == "some coldetail"
      assert loan_applications_sme.documentdetail == "some documentdetail"
      assert loan_applications_sme.financetype == 42
      assert loan_applications_sme.productcode == "some productcode"
      assert loan_applications_sme.coldoc == "some coldoc"
      assert loan_applications_sme.invoicedetails == "some invoicedetails"
      assert loan_applications_sme.orgcode == "some orgcode"
      assert loan_applications_sme.offtakerid == "some offtakerid"
      assert loan_applications_sme.vendorcode == "some vendorcode"
    end

    test "create_loan_applications_sme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LoanApplications.create_loan_applications_sme(@invalid_attrs)
    end

    test "update_loan_applications_sme/2 with valid data updates the loan_applications_sme" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert {:ok, %LoanApplicationsSme{} = loan_applications_sme} = LoanApplications.update_loan_applications_sme(loan_applications_sme, @update_attrs)
      assert loan_applications_sme.Loan == "some updated Loan"
      assert loan_applications_sme.invoicedoc == "some updated invoicedoc"
      assert loan_applications_sme.collateralvalue == Decimal.new("456.7")
      assert loan_applications_sme.facility == Decimal.new("456.7")
      assert loan_applications_sme.phx.gen.context == "some updated phx.gen.context"
      assert loan_applications_sme.Guarantor == "some updated Guarantor"
      assert loan_applications_sme.conversationid == "some updated conversationid"
      assert loan_applications_sme.Loanpurpose == "some updated Loanpurpose"
      assert loan_applications_sme.invoicedate == ~D[2011-05-18]
      assert loan_applications_sme.coldocumentname == "some updated coldocumentname"
      assert loan_applications_sme.invoiceno == "some updated invoiceno"
      assert loan_applications_sme.tag == "some updated tag"
      assert loan_applications_sme.Loandate == ~D[2011-05-18]
      assert loan_applications_sme.customername == "some updated customername"
      assert loan_applications_sme.branch == "some updated branch"
      assert loan_applications_sme.documenttype == 43
      assert loan_applications_sme.tbl_sme_loan_application == "some updated tbl_sme_loan_application"
      assert loan_applications_sme.registrationno == "some updated registrationno"
      assert loan_applications_sme.appraisedvalue == Decimal.new("456.7")
      assert loan_applications_sme.invoiceexpirydate == ~D[2011-05-18]
      assert loan_applications_sme.fininstitutionname == "some updated fininstitutionname"
      assert loan_applications_sme.exposure == "some updated exposure"
      assert loan_applications_sme.invoicevalue == Decimal.new("456.7")
      assert loan_applications_sme.mix == "some updated mix"
      assert loan_applications_sme.loandoc == "some updated loandoc"
      assert loan_applications_sme.loanamount == Decimal.new("456.7")
      assert loan_applications_sme.maturitydate == ~D[2011-05-18]
      assert loan_applications_sme.coldetail == "some updated coldetail"
      assert loan_applications_sme.documentdetail == "some updated documentdetail"
      assert loan_applications_sme.financetype == 43
      assert loan_applications_sme.productcode == "some updated productcode"
      assert loan_applications_sme.coldoc == "some updated coldoc"
      assert loan_applications_sme.invoicedetails == "some updated invoicedetails"
      assert loan_applications_sme.orgcode == "some updated orgcode"
      assert loan_applications_sme.offtakerid == "some updated offtakerid"
      assert loan_applications_sme.vendorcode == "some updated vendorcode"
    end

    test "update_loan_applications_sme/2 with invalid data returns error changeset" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert {:error, %Ecto.Changeset{}} = LoanApplications.update_loan_applications_sme(loan_applications_sme, @invalid_attrs)
      assert loan_applications_sme == LoanApplications.get_loan_applications_sme!(loan_applications_sme.id)
    end

    test "delete_loan_applications_sme/1 deletes the loan_applications_sme" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert {:ok, %LoanApplicationsSme{}} = LoanApplications.delete_loan_applications_sme(loan_applications_sme)
      assert_raise Ecto.NoResultsError, fn -> LoanApplications.get_loan_applications_sme!(loan_applications_sme.id) end
    end

    test "change_loan_applications_sme/1 returns a loan_applications_sme changeset" do
      loan_applications_sme = loan_applications_sme_fixture()
      assert %Ecto.Changeset{} = LoanApplications.change_loan_applications_sme(loan_applications_sme)
    end
  end

  describe "tbl_employee_loan_application" do
    alias LoanSavingsSystem.LoanApplications.LoanApplicationsEmployee

    @valid_attrs %{amount: "120.5", kinmaritalstatusid: 42, forceclosuredate: ~D[2010-04-17], employerproductmapid: "some employerproductmapid", mobileno: "some mobileno", kinoccupation: "some kinoccupation", employercode: "some employercode", bankname: "some bankname", isforceclosur: "some isforceclosur", occupation: "some occupation", payoffamount: "120.5", payoffinstitution: "some payoffinstitution", branchcode: "some branchcode", maritalstatusid: 42, division: "some division", employementstartdate: ~D[2010-04-17], kintitleid: 42, loanpurposeid: 42, titleid: 42, kinfirstname: "some kinfirstname", postalcode1: "some postalcode1", address1: "some address1", kindob: ~D[2010-04-17], postalcode2: "some postalcode2", firstname: "some firstname", nationalityid: 42, address2: "some address2", customerid: "some customerid", countryid2: 42, bankbranch: "some bankbranch", passportno: "some passportno", loantypeid: 42, districtid2: 42, kintelephonenumber: "some kintelephonenumber", payoffmode: "some payoffmode", custtype: "some custtype", kinlastname: "some kinlastname", provinceid1: 42, countryid1: 42, workphone: "some workphone", ispayoff: "some ispayoff", loanamount: "120.5", employmenttypeid: 42, bankaccountno: "some bankaccountno", salarycomponent: "some salarycomponent", forceclosureloanid: "some forceclosureloanid", kinmiddlename: "some kinmiddlename", kinrelationshipid: 42, orgcode: "some orgcode", document_doccontent: "some document_doccontent", ...}
    @update_attrs %{amount: "456.7", kinmaritalstatusid: 43, forceclosuredate: ~D[2011-05-18], employerproductmapid: "some updated employerproductmapid", mobileno: "some updated mobileno", kinoccupation: "some updated kinoccupation", employercode: "some updated employercode", bankname: "some updated bankname", isforceclosur: "some updated isforceclosur", occupation: "some updated occupation", payoffamount: "456.7", payoffinstitution: "some updated payoffinstitution", branchcode: "some updated branchcode", maritalstatusid: 43, division: "some updated division", employementstartdate: ~D[2011-05-18], kintitleid: 43, loanpurposeid: 43, titleid: 43, kinfirstname: "some updated kinfirstname", postalcode1: "some updated postalcode1", address1: "some updated address1", kindob: ~D[2011-05-18], postalcode2: "some updated postalcode2", firstname: "some updated firstname", nationalityid: 43, address2: "some updated address2", customerid: "some updated customerid", countryid2: 43, bankbranch: "some updated bankbranch", passportno: "some updated passportno", loantypeid: 43, districtid2: 43, kintelephonenumber: "some updated kintelephonenumber", payoffmode: "some updated payoffmode", custtype: "some updated custtype", kinlastname: "some updated kinlastname", provinceid1: 43, countryid1: 43, workphone: "some updated workphone", ispayoff: "some updated ispayoff", loanamount: "456.7", employmenttypeid: 43, bankaccountno: "some updated bankaccountno", salarycomponent: "some updated salarycomponent", forceclosureloanid: "some updated forceclosureloanid", kinmiddlename: "some updated kinmiddlename", kinrelationshipid: 43, orgcode: "some updated orgcode", document_doccontent: "some updated document_doccontent", ...}
    @invalid_attrs %{amount: nil, kinmaritalstatusid: nil, forceclosuredate: nil, employerproductmapid: nil, mobileno: nil, kinoccupation: nil, employercode: nil, bankname: nil, isforceclosur: nil, occupation: nil, payoffamount: nil, payoffinstitution: nil, branchcode: nil, maritalstatusid: nil, division: nil, employementstartdate: nil, kintitleid: nil, loanpurposeid: nil, titleid: nil, kinfirstname: nil, postalcode1: nil, address1: nil, kindob: nil, postalcode2: nil, firstname: nil, nationalityid: nil, address2: nil, customerid: nil, countryid2: nil, bankbranch: nil, passportno: nil, loantypeid: nil, districtid2: nil, kintelephonenumber: nil, payoffmode: nil, custtype: nil, kinlastname: nil, provinceid1: nil, countryid1: nil, workphone: nil, ispayoff: nil, loanamount: nil, employmenttypeid: nil, bankaccountno: nil, salarycomponent: nil, forceclosureloanid: nil, kinmiddlename: nil, kinrelationshipid: nil, orgcode: nil, document_doccontent: nil, ...}

    def loan_applications_employee_fixture(attrs \\ %{}) do
      {:ok, loan_applications_employee} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LoanApplications.create_loan_applications_employee()

      loan_applications_employee
    end

    test "list_tbl_employee_loan_application/0 returns all tbl_employee_loan_application" do
      loan_applications_employee = loan_applications_employee_fixture()
      assert LoanApplications.list_tbl_employee_loan_application() == [loan_applications_employee]
    end

    test "get_loan_applications_employee!/1 returns the loan_applications_employee with given id" do
      loan_applications_employee = loan_applications_employee_fixture()
      assert LoanApplications.get_loan_applications_employee!(loan_applications_employee.id) == loan_applications_employee
    end

    test "create_loan_applications_employee/1 with valid data creates a loan_applications_employee" do
      assert {:ok, %LoanApplicationsEmployee{} = loan_applications_employee} = LoanApplications.create_loan_applications_employee(@valid_attrs)
      assert loan_applications_employee.payoffaccountnumber == "some payoffaccountnumber"
      assert loan_applications_employee.nrc == "some nrc"
      assert loan_applications_employee.bankaccounttype == "some bankaccounttype"
      assert loan_applications_employee.districtid1 == 42
      assert loan_applications_employee.provinceid2 == 42
      assert loan_applications_employee.kinnrcid == "some kinnrcid"
      assert loan_applications_employee.contractenddate == ~D[2010-04-17]
      assert loan_applications_employee.emailid == "some emailid"
      assert loan_applications_employee.document == "some document"
      assert loan_applications_employee.dob == ~D[2010-04-17]
      assert loan_applications_employee.payoffbranch == "some payoffbranch"
      assert loan_applications_employee.loandate == ~D[2010-04-17]
      assert loan_applications_employee.lastname == "some lastname"
      assert loan_applications_employee.conversationid == "some conversationid"
      assert loan_applications_employee.employeeid == "some employeeid"
      assert loan_applications_employee.salarycomponenttypeid == 42
      assert loan_applications_employee.kinmobilenumber == "some kinmobilenumber"
      assert loan_applications_employee.genderid == 42
      assert loan_applications_employee.vendorcode == "some vendorcode"
      assert loan_applications_employee.kinplaceofwork == "some kinplaceofwork"
      assert loan_applications_employee.homephone == "some homephone"
      assert loan_applications_employee.tag == "some tag"
      assert loan_applications_employee.drivinglicenseno == "some drivinglicenseno"
      assert loan_applications_employee.kingenderid == 42
      assert loan_applications_employee.bankaccountname == "some bankaccountname"
      assert loan_applications_employee.doctypeid == 42
      assert loan_applications_employee.middlename == "some middlename"
      assert loan_applications_employee.document_doccontent == "some document_doccontent"
      assert loan_applications_employee.orgcode == "some orgcode"
      assert loan_applications_employee.kinrelationshipid == 42
      assert loan_applications_employee.kinmiddlename == "some kinmiddlename"
      assert loan_applications_employee.forceclosureloanid == "some forceclosureloanid"
      assert loan_applications_employee.salarycomponent == "some salarycomponent"
      assert loan_applications_employee.bankaccountno == "some bankaccountno"
      assert loan_applications_employee.employmenttypeid == 42
      assert loan_applications_employee.loanamount == Decimal.new("120.5")
      assert loan_applications_employee.ispayoff == "some ispayoff"
      assert loan_applications_employee.workphone == "some workphone"
      assert loan_applications_employee.countryid1 == 42
      assert loan_applications_employee.provinceid1 == 42
      assert loan_applications_employee.kinlastname == "some kinlastname"
      assert loan_applications_employee.custtype == "some custtype"
      assert loan_applications_employee.payoffmode == "some payoffmode"
      assert loan_applications_employee.kintelephonenumber == "some kintelephonenumber"
      assert loan_applications_employee.districtid2 == 42
      assert loan_applications_employee.loantypeid == 42
      assert loan_applications_employee.passportno == "some passportno"
      assert loan_applications_employee.bankbranch == "some bankbranch"
      assert loan_applications_employee.countryid2 == 42
      assert loan_applications_employee.customerid == "some customerid"
      assert loan_applications_employee.address2 == "some address2"
      assert loan_applications_employee.nationalityid == 42
      assert loan_applications_employee.firstname == "some firstname"
      assert loan_applications_employee.postalcode2 == "some postalcode2"
      assert loan_applications_employee.kindob == ~D[2010-04-17]
      assert loan_applications_employee.address1 == "some address1"
      assert loan_applications_employee.postalcode1 == "some postalcode1"
      assert loan_applications_employee.kinfirstname == "some kinfirstname"
      assert loan_applications_employee.titleid == 42
      assert loan_applications_employee.loanpurposeid == 42
      assert loan_applications_employee.kintitleid == 42
      assert loan_applications_employee.employementstartdate == ~D[2010-04-17]
      assert loan_applications_employee.division == "some division"
      assert loan_applications_employee.maritalstatusid == 42
      assert loan_applications_employee.branchcode == "some branchcode"
      assert loan_applications_employee.payoffinstitution == "some payoffinstitution"
      assert loan_applications_employee.payoffamount == Decimal.new("120.5")
      assert loan_applications_employee.occupation == "some occupation"
      assert loan_applications_employee.isforceclosur == "some isforceclosur"
      assert loan_applications_employee.bankname == "some bankname"
      assert loan_applications_employee.employercode == "some employercode"
      assert loan_applications_employee.kinoccupation == "some kinoccupation"
      assert loan_applications_employee.mobileno == "some mobileno"
      assert loan_applications_employee.employerproductmapid == "some employerproductmapid"
      assert loan_applications_employee.forceclosuredate == ~D[2010-04-17]
      assert loan_applications_employee.kinmaritalstatusid == 42
      assert loan_applications_employee.amount == Decimal.new("120.5")
    end

    test "create_loan_applications_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LoanApplications.create_loan_applications_employee(@invalid_attrs)
    end

    test "update_loan_applications_employee/2 with valid data updates the loan_applications_employee" do
      loan_applications_employee = loan_applications_employee_fixture()
      assert {:ok, %LoanApplicationsEmployee{} = loan_applications_employee} = LoanApplications.update_loan_applications_employee(loan_applications_employee, @update_attrs)
      assert loan_applications_employee.payoffaccountnumber == "some updated payoffaccountnumber"
      assert loan_applications_employee.nrc == "some updated nrc"
      assert loan_applications_employee.bankaccounttype == "some updated bankaccounttype"
      assert loan_applications_employee.districtid1 == 43
      assert loan_applications_employee.provinceid2 == 43
      assert loan_applications_employee.kinnrcid == "some updated kinnrcid"
      assert loan_applications_employee.contractenddate == ~D[2011-05-18]
      assert loan_applications_employee.emailid == "some updated emailid"
      assert loan_applications_employee.document == "some updated document"
      assert loan_applications_employee.dob == ~D[2011-05-18]
      assert loan_applications_employee.payoffbranch == "some updated payoffbranch"
      assert loan_applications_employee.loandate == ~D[2011-05-18]
      assert loan_applications_employee.lastname == "some updated lastname"
      assert loan_applications_employee.conversationid == "some updated conversationid"
      assert loan_applications_employee.employeeid == "some updated employeeid"
      assert loan_applications_employee.salarycomponenttypeid == 43
      assert loan_applications_employee.kinmobilenumber == "some updated kinmobilenumber"
      assert loan_applications_employee.genderid == 43
      assert loan_applications_employee.vendorcode == "some updated vendorcode"
      assert loan_applications_employee.kinplaceofwork == "some updated kinplaceofwork"
      assert loan_applications_employee.homephone == "some updated homephone"
      assert loan_applications_employee.tag == "some updated tag"
      assert loan_applications_employee.drivinglicenseno == "some updated drivinglicenseno"
      assert loan_applications_employee.kingenderid == 43
      assert loan_applications_employee.bankaccountname == "some updated bankaccountname"
      assert loan_applications_employee.doctypeid == 43
      assert loan_applications_employee.middlename == "some updated middlename"
      assert loan_applications_employee.document_doccontent == "some updated document_doccontent"
      assert loan_applications_employee.orgcode == "some updated orgcode"
      assert loan_applications_employee.kinrelationshipid == 43
      assert loan_applications_employee.kinmiddlename == "some updated kinmiddlename"
      assert loan_applications_employee.forceclosureloanid == "some updated forceclosureloanid"
      assert loan_applications_employee.salarycomponent == "some updated salarycomponent"
      assert loan_applications_employee.bankaccountno == "some updated bankaccountno"
      assert loan_applications_employee.employmenttypeid == 43
      assert loan_applications_employee.loanamount == Decimal.new("456.7")
      assert loan_applications_employee.ispayoff == "some updated ispayoff"
      assert loan_applications_employee.workphone == "some updated workphone"
      assert loan_applications_employee.countryid1 == 43
      assert loan_applications_employee.provinceid1 == 43
      assert loan_applications_employee.kinlastname == "some updated kinlastname"
      assert loan_applications_employee.custtype == "some updated custtype"
      assert loan_applications_employee.payoffmode == "some updated payoffmode"
      assert loan_applications_employee.kintelephonenumber == "some updated kintelephonenumber"
      assert loan_applications_employee.districtid2 == 43
      assert loan_applications_employee.loantypeid == 43
      assert loan_applications_employee.passportno == "some updated passportno"
      assert loan_applications_employee.bankbranch == "some updated bankbranch"
      assert loan_applications_employee.countryid2 == 43
      assert loan_applications_employee.customerid == "some updated customerid"
      assert loan_applications_employee.address2 == "some updated address2"
      assert loan_applications_employee.nationalityid == 43
      assert loan_applications_employee.firstname == "some updated firstname"
      assert loan_applications_employee.postalcode2 == "some updated postalcode2"
      assert loan_applications_employee.kindob == ~D[2011-05-18]
      assert loan_applications_employee.address1 == "some updated address1"
      assert loan_applications_employee.postalcode1 == "some updated postalcode1"
      assert loan_applications_employee.kinfirstname == "some updated kinfirstname"
      assert loan_applications_employee.titleid == 43
      assert loan_applications_employee.loanpurposeid == 43
      assert loan_applications_employee.kintitleid == 43
      assert loan_applications_employee.employementstartdate == ~D[2011-05-18]
      assert loan_applications_employee.division == "some updated division"
      assert loan_applications_employee.maritalstatusid == 43
      assert loan_applications_employee.branchcode == "some updated branchcode"
      assert loan_applications_employee.payoffinstitution == "some updated payoffinstitution"
      assert loan_applications_employee.payoffamount == Decimal.new("456.7")
      assert loan_applications_employee.occupation == "some updated occupation"
      assert loan_applications_employee.isforceclosur == "some updated isforceclosur"
      assert loan_applications_employee.bankname == "some updated bankname"
      assert loan_applications_employee.employercode == "some updated employercode"
      assert loan_applications_employee.kinoccupation == "some updated kinoccupation"
      assert loan_applications_employee.mobileno == "some updated mobileno"
      assert loan_applications_employee.employerproductmapid == "some updated employerproductmapid"
      assert loan_applications_employee.forceclosuredate == ~D[2011-05-18]
      assert loan_applications_employee.kinmaritalstatusid == 43
      assert loan_applications_employee.amount == Decimal.new("456.7")
    end

    test "update_loan_applications_employee/2 with invalid data returns error changeset" do
      loan_applications_employee = loan_applications_employee_fixture()
      assert {:error, %Ecto.Changeset{}} = LoanApplications.update_loan_applications_employee(loan_applications_employee, @invalid_attrs)
      assert loan_applications_employee == LoanApplications.get_loan_applications_employee!(loan_applications_employee.id)
    end

    test "delete_loan_applications_employee/1 deletes the loan_applications_employee" do
      loan_applications_employee = loan_applications_employee_fixture()
      assert {:ok, %LoanApplicationsEmployee{}} = LoanApplications.delete_loan_applications_employee(loan_applications_employee)
      assert_raise Ecto.NoResultsError, fn -> LoanApplications.get_loan_applications_employee!(loan_applications_employee.id) end
    end

    test "change_loan_applications_employee/1 returns a loan_applications_employee changeset" do
      loan_applications_employee = loan_applications_employee_fixture()
      assert %Ecto.Changeset{} = LoanApplications.change_loan_applications_employee(loan_applications_employee)
    end
  end
end
