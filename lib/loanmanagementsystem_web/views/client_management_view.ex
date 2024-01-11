defmodule LoanmanagementsystemWeb.ClientManagementView do
  use LoanmanagementsystemWeb, :view

  def required_document do
    [
      %{name: "NRC", is_required: true},
      %{name: "TPIN Certificate", is_required: true},
      %{name: "APPLICANT SIGNATURE", is_required: true},
      %{name: "BANK REP SIGNATURE", is_required: true}
    ]
  end

  def client_document_upload do
    [
      %{name: "NRC", is_required: true},
      %{name: "TPIN Certificate", is_required: true}
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
