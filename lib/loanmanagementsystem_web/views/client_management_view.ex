defmodule LoanmanagementsystemWeb.ClientManagementView do
  use LoanmanagementsystemWeb, :view

  def required_document do
    [
      %{name: "Certified copy NRC ", is_required: true},
      %{name: "Passport size photo", is_required: true},
      %{name: "Proof of residential address", is_required: true},
      %{name: "Signature photo ", is_required: true}
    ]
  end

  def client_document_upload do
    [
      %{name: "Certified copy NRC ", is_required: true},
      %{name: "Passport size photo", is_required: true},
      %{name: "Proof of residential address", is_required: true},
      %{name: "Signature photo ", is_required: true}
    ]
  end

  def signature_file_upload do
    [
      %{name: "Signature File ", is_required: true}
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
