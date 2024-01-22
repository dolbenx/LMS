defmodule LoanmanagementsystemWeb.LoanView do
  use LoanmanagementsystemWeb, :view

  def quick_loan_document_upload do
    [
      %{name: "Latest Payslip", is_required: true},
      %{name: "Latest Bank Statement", is_required: true}
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
