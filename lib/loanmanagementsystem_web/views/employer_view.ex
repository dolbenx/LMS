defmodule LoanmanagementsystemWeb.EmployerView do
  use LoanmanagementsystemWeb, :view

  def required_document do
    [
      %{name: "NRC", is_required: true}
    ]
  end

  def client_upload_loan_document do
    [
      %{name: "Facility Agreement Form(signed by client)", is_required: true},
      %{name: "Guarantee form(signed by client)", is_required: true},
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
