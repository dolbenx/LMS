defmodule LoanmanagementsystemWeb.LoanView do
  use LoanmanagementsystemWeb, :view

  def quick_loan_document_upload do
    [
      %{name: "Invoice Copy", is_required: true},
      %{name: "Board Resolutions to borrow", is_required: true},
      %{name: "Supplier’s Irrevocable Assignment of Receivables letter ", is_required: true}
    ]
  end



  def quick_loan_document_upload_no_mou do
    [
      %{name: "Invoice Copy", is_required: true},
      %{name: "Board Resolutions to borrow", is_required: true},
      %{name: "Business plan/Company Profile", is_required: true},
      %{name: "Audited Financial Statement/Management Accounts or Bank statements on business account for the past 4 Months", is_required: true},
      %{name: "6-12 months cash flow projections", is_required: true},
      %{name: "Business plan/Company Profile", is_required: true}
    ]
  end

  def sme_loan_application_document_upload do
    [
      # %{name: "Invoice Copy", is_required: true},
      %{name: "Board Resolutions to borrow", is_required: true},
      %{name: "Business plan/Company Profile", is_required: true},
      %{name: "Audited Financial Statement/Management Accounts or Bank statements on business account for the past 4 Months", is_required: true},
      %{name: "6-12 months cash flow projections", is_required: true},
      %{name: "Proof of Collateral", is_required: true},
    ]
  end

  def order_finance_document_upload do
    [
      %{name: "Proforma Invoice", is_required: true},
      # %{name: "Copy of order", is_required: true},
      %{name: "Purchase Order", is_required: true},
      %{name: "Board Resolutions to borrow", is_required: true},
      %{name: "Business plan/Company Profile", is_required: true},
      %{name: "Audited Financial Statements/4 Months Bank Statement", is_required: true},
      %{name: "6-12 months cash flow projections", is_required: true},
      %{name: "Proof of Collateral", is_required: true},
    ]
  end


  def accountant_order_finance_document_upload do
    [
      %{name: "Proof of Payment", is_required: true},
    ]
  end


  def accountant_loan_repayment_document_upload do
    [
      %{name: "Proof of Payment", is_required: true},
    ]
  end

  def consumer_loan_document_upload do
    [
      %{name: "Bank statements", is_required: true},
      %{name: "Post-dated Cheques", is_required: true},
    ]
  end

  def consumer_loan_application_document_upload do
    [
      %{name: "NRC", is_required: true},
      %{name: "Passpoart Size Photo", is_required: true},
      %{name: "3 Latest Pay slips", is_required: true},
      %{name: "Four Past statements on salaried account", is_required: true},
      %{name: "Post-dated cheques", is_required: true},
      %{name: "Proof of residency", is_required: true},

    ]
  end


  def invoice_discounting_loan_document_upload_mou do
    [
      # %{name: "Offtaker confirmation letter", is_required: true},
      %{name: "Invoice Copy", is_required: true},
      %{name: "Letter of Assignment of Receivables", is_required: true},
      %{name: "Board Resolution to Borrow", is_required: true},
    ]
  end

  def invoice_discounting_loan_document_upload_no_mou do
    [
      %{name: "Invoice Copy", is_required: true},
      %{name: "Board Resolutions to borrow", is_required: true},
      %{name: "Business plan/Company Profile ", is_required: true},
      %{name: "Bank statements on business account for the past 4 months", is_required: true},
      %{name: "6-12 months cash flow projections", is_required: true},
      %{name: "Proof Of Collateral", is_required: true}
    ]
  end

  def approve_credit_loan_document_upload_mou do
    [
      %{name: "Schedule of funds due to the funding partner ", is_required: true},
      %{name: "Schedule of net amounts (after repayment of interest and principal) due to clients ", is_required: true}
    ]
  end

  def approve_credit_from_ceo_loan_document_upload_mou do
    [
      %{name: "Guarantee Form", is_required: true},
      %{name: "Facility Agreement", is_required: true},
    ]
  end

  def approve_credit_from_ceo_loan_document_upload_mou_no do
    [

      %{name: "Original Collateral documents", is_required: true},
      %{name: "Guarantee Form", is_required: true},
      %{name: "Facility Agreement", is_required: true},
    ]
  end

  def approve_credit_external_credit_manager do
    [
      %{name: "Guarantee Form", is_required: true},
      %{name: "Facility Agreement", is_required: true},
      %{name: "Offtaker Confirmation Documents", is_required: true},
      # %{name: "Confirmation of invoice", is_required: true},
      # %{name: "Acknowledgement of assignment of recievables", is_required: true},
    ]
  end

  def approve_credit_before_credit_manager do
    [
      %{name: "Credit Assessment Report", is_required: true},
      # %{name: "Confirmation of invoice", is_required: true},
      # %{name: "Acknowledgement of assignment of recievables", is_required: true},
      %{name: "Offtaker Confirmation Documents", is_required: true},
    ]
  end

  def approve_credit_before_credit_manager_mou_internal do
    [
      %{name: "Offtaker Confirmation Documents", is_required: true},
      # %{name: "Acknowledgement of assignment of recievables", is_required: true},
    ]
  end


  def approve_credit_invoice_loan_document_upload_no_mou do
    [
      %{name: "Credit Report ", is_required: true},
    ]
  end

  def approve_accounts_loan_document_upload_mou do
    [
      %{name: "Disbursed Funds List", is_required: true},
      %{name: "Proof of Payment", is_required: true},
      %{name: "Proof of Payment of Clients", is_required: true},
    ]
  end


  def pending_credit_approval_for_ordering_finance do
    [
      %{name: "Credit Report", is_required: true},
      %{name: "Proof of Payment for Client & Supplier", is_required: true}
    ]
  end

  def approve_accounts_loan_document_upload_no_mou do
    [
      %{name: "Proof of Payment", is_required: true},
      # %{name: "Disbursed Funds List", is_required: true},
      # %{name: "Proof of Payment by Funding Partner", is_required: true}
    ]
  end

  def approve_accounts_invoice_loan_document_upload_mou do
    [
      %{name: "Proof of Payment", is_required: true},
    ]
  end


  def admin_approve_operations_loan_document_upload_no_mou_miz do
    [
      %{name: "Credit Report", is_required: true}
    ]
  end

  def approve_operations_loan_document_upload_mou do
    [
      %{name: "Credit Report ", is_required: true}
    ]
  end

  def approve_operations_loan_document_upload_no_mou do
    [
      %{name: "Credit Report ", is_required: true}
    ]
  end

  def approve_consumer_loan_credit__loan_document_upload do
    [
      %{name: "Credit Report", is_required: true},
      %{name: "Facility Agreement and Loan Guarantee form", is_required: true},
      %{name: "Proof of Payment", is_required: true},
      %{name: "Schedule of funds due to the funding partner", is_required: true},
    ]
  end


  def approve_consumer_loan_accountant_loan_document_upload do
    [
      %{name: "Proof of payment", is_required: true},
    ]
  end

  def approve_consumer_loan_operations_officer_document_upload do
    [
      %{name: "Credit Report", is_required: true}
    ]
  end


  def admin_credit_analyst_credit_report_upload do
    [
      %{name: "Offtaker Confirmation", is_required: true},
      %{name: "Credit Report", is_required: true},

    ]
  end

  def admin_credit_analyst_rview_report_upload do
    [
      %{name: "Facility Agreement Form", is_required: true},
      %{name: "Garantor Form", is_required: true},
      %{name: "Original Collateral Document & Letter Of Sale", is_required: true}
    ]
  end


  def admin_loan_officer_approval_with_documents do
    [
      %{name: "Proof Of Collateral", is_required: true}
    ]
  end

  def credit_analyst_approve_consumer_loan_application_document_upload do
    [
      %{name: "Credit Report", is_required: true},

    ]
  end

  def review_sme_loan_by_credit_analyst_document_upload do
    [
      %{name: "Credit Report", is_required: true},
      # %{name: "Original Collateral Document & Letter Of Sale", is_required: true},
    ]
  end


  def credit_analyst_loan_repayment_document_upload do
    [
      # %{name: "Schedule Report", is_required: true},
      %{name: "Statement of Account", is_required: true},

    ]
  end

  def credit_analyst_approve_consumer_loan_from_mgt_document_upload do
    [
      %{name: "Guarantor Form ", is_required: true},
      %{name: "Facility Agreement", is_required: true},
    ]
  end

  def is_required?(state) do
    if state == true do
      "required"
    else
      ""
    end
  end

  def is_required(state) do
    if state == true do
      " (required) "
    else
      " (optional) "
    end
  end
end
