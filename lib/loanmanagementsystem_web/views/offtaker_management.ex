defmodule LoanmanagementsystemWeb.OfftakerManagementView do
  use LoanmanagementsystemWeb, :view

  def required_document do
    [
      %{name: "Company registration certificate", is_required: true},
      %{name: "Article of association", is_required: true},
      %{name: "Stamped PACRA Printout/Form3", is_required: true},
      %{name: "Tax Clearance certificate", is_required: true},
      %{name: "Certified copy of NRCs ", is_required: false},
      %{name: "Passport size photos", is_required: true},
      %{name: "Proof of residential address ", is_required: false},
      %{name: "Confirmation of operating address for company", is_required: true}
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
      " (of each shareholder/director of the business) "
    end
  end
end
