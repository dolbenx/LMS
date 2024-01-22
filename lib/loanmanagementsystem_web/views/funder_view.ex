defmodule LoanmanagementsystemWeb.FunderView do
  use LoanmanagementsystemWeb, :view

  def approve_funder_loan_document_upload do
    [
      %{name: "Proof of Payment by Funding Partner", is_required: true}
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
