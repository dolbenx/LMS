defmodule LoanmanagementsystemWeb.EmployeeView do
  use LoanmanagementsystemWeb, :view

  def employee_loan_application_document_upload do
    [
      %{name: "NRC", is_required: true},
      %{name: "Passpoart Size Photo", is_required: true},
      %{name: "3 Latest Pay slips", is_required: true},
      %{name: "Four Past statements on salaried account", is_required: true},
      %{name: "Proof of residency", is_required: true},

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
